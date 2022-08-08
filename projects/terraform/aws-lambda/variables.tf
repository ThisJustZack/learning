variable "aws_region" {
    description = "AWS region for infrastructure resources"
    type = string
    default = "us-east-1"
}

variable "role_name" {
    description = "Role name for AWS IAM"
    type = string
    default = "serverless_lambda"
}

variable "lambda_function_name" {
    description = "Function name for AWS Lambda function"
    type = string
    default = "Interactions"
}

variable "lambda_runtime" {
    description = "Runtime language used for AWS Lambda function"
    type = string
    default = "nodejs14.x"
}

variable "lambda_handler" {
    description = "Lambda function handler for AWS Lambda function"
    type = string
    default = "handler.index.interactions"
}

variable "gateway_name" {
    description = "Name for AWS API Gateway"
    type = string
    default = "InteractionsGateway"
}