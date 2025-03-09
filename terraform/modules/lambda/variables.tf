variable "region" {
  description = "AWS Region"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "iam_role_arn" {
  description = "ARN of the IAM role for Lambda"
  type        = string
}

variable "image_uri" {
  description = "URI of the Docker image for Lambda function"
  type        = string
}

variable "environment" {
  description = "Environment for Lambda"
  type        = string
}

variable "api_stage" {
  description = "API Gateway stage"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

variable "user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  type        = string
}
