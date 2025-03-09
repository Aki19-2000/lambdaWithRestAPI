output "lambda_function_arn" {
  value = aws_lambda_function.hello_world_function.arn
}

output "api_gateway_id" {
  value = aws_apigatewayv2_api.api_gateway.id
}
