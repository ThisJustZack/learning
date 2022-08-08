terraform {
    required_providers {
        aws     = {
            source  = "hashicorp/aws"
            version = "~> 4.0.0"
        }
        archive = {
            source  = "hashicorp/archive"
            version = "~> 2.2.0"
        }
    }
    required_version = "~> 1.0"
}

provider "aws" {
    region = var.aws_region
}

resource "aws_iam_role" "lambda_role" {
    name                = var.role_name
    assume_role_policy  = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role        = aws_iam_role.lambda_role.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "zip_code" {
    type        = "zip"
    source_dir  = "${path.module}/src/main"
    output_path = "${path.module}/src/main.zip"
}

resource "aws_lambda_function" "lambda_function" {
    filename            = data.archive_file.zip_code.output_path
    function_name       = var.lambda_function_name
    runtime             = var.lambda_runtime
    handler             = var.lambda_handler
    source_code_hash    = data.archive_file.zip_code.output_base64sha256
    role                = aws_iam_role.lambda_role.arn
}

resource "aws_apigatewayv2_api" "gateway_api" {
    name            = var.gateway_name
    protocol_type   = "HTTP"
}

resource "aws_cloudwatch_log_group" "logging" {
    name                = "/aws/gateway_api/${aws_apigatewayv2_api.gateway_api.name}"
    retention_in_days   = 30
}

resource "aws_apigatewayv2_integration" "gateway_integration" {
    api_id              = aws_apigatewayv2_api.gateway_api.id
    integration_uri     = aws_lambda_function.lambda_function.invoke_arn
    integration_type    = "AWS_PROXY"
    integration_method  = "POST"
}

resource "aws_apigatewayv2_stage" "gateway_logging" {
    api_id      = aws_apigatewayv2_api.gateway_api.id
    name        = "${var.gateway_name}_stage"
    auto_deploy = true
    access_log_settings {
        destination_arn = aws_cloudwatch_log_group.logging.arn
        format = jsonencode({
            requestId               = "$context.requestId"
            sourceIp                = "$context.identity.sourceIp"
            requestTime             = "$context.requestTime"
            protocol                = "$context.protocol"
            httpMethod              = "$context.httpMethod"
            resourcePath            = "$context.resourcePath"
            routeKey                = "$context.routeKey"
            status                  = "$context.status"
            responseLength          = "$context.responseLength"
            integrationErrorMessage = "$context.integrationErrorMessage"
        })
    }
}

resource "aws_apigatewayv2_route" "gateway_route" {
    api_id      = aws_apigatewayv2_api.gateway_api.id
    route_key   = "GET /${var.lambda_function_name}"
    target      = "integrations/${aws_apigatewayv2_integration.gateway_integration.id}"
}

resource "aws_lambda_permission" "gateway_management" {
    statement_id    = "AllowExececutionFromAPIGateWay"
    action          = "lambda:InvokeFunction"
    function_name   = aws_lambda_function.lambda_function.function_name
    principal       = "apigateway.amazonaws.com"
    source_arn      = "${aws_apigatewayv2_api.gateway_api.execution_arn}/*/*"
}