provider "aws" {
  region = var.aws_region  # Use the region variable from the root module
}

module "iam" {
  source               = "./modules/iam"
  aws_region           = var.aws_region       # Pass region to IAM module
  account_id           = var.account_id       # Pass account ID to IAM module
  lambda_function_name = var.lambda_function_name  # Pass Lambda function name
}

module "cognito" {
  source = "./modules/cognito"
}

module "lambda_api" {
  source               = "./modules/lambda"
  region               = var.aws_region
  lambda_function_name = var.lambda_function_name
  iam_role_arn         = module.iam.lambda_role_arn
  image_uri            = var.image_uri
  environment          = "prd"
  api_stage            = "prod"
  account_id           = var.account_id
  user_pool_id         = module.cognito.user_pool_id
  user_pool_client_id  = module.cognito.user_pool_client_id
}

output "lambda_function_arn" {
  value = module.lambda_api.lambda_function_arn
}

output "api_gateway_url" {
  value = "https://${module.lambda_api.api_gateway_id}.execute-api.${var.aws_region}.amazonaws.com/prod"
}
