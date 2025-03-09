variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "image_uri" {
  description = "URI of the Docker image for Lambda function"
  type        = string
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}
