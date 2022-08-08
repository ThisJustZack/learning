output "function_name" {
    description = "Name of Lambda function"
    value = aws_lambda_function.hello_world.function_name
}

output "base_url" {
    description = "URL for Gateway API"
    value = aws_apigatewayv2_stage.gateway_logging.invoke_url
}