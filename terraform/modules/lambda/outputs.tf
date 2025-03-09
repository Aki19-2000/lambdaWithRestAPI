output "lambda_function_arn" {
  value = aws_lambda_function.hello_world_function.arn
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api_gateway.id
}
