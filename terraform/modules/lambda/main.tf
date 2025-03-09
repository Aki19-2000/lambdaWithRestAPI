resource "aws_lambda_function" "hello_world_function" {
  function_name = var.lambda_function_name
  role          = var.iam_role_arn
  image_uri     = var.image_uri
  package_type  = "Image"

  environment {
    variables = {
      ENV = var.environment
    }
  }

  tracing_config {
    mode = "Active"  # This enables X-Ray tracing for the Lambda function
  }
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "hello-world-api"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_authorizer" "jwt_authorizer" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  name        = "jwt-authorizer"
  type        = "COGNITO_USER_POOLS"
  provider_arns = [
    "arn:aws:cognito-idp:us-east-1:${var.aws_account_id}:userpool/${var.user_pool_id}"
  ]
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.jwt_authorizer.id
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_world_function.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = var.api_stage

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}
