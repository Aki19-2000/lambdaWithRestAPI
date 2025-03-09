resource "aws_cognito_user_pool" "user_pool" {
  name = "my-user-pool"
 
  username_attributes = ["email"]
  auto_verified_attributes = ["email"]
}
 
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "my-user-pool-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
 
  allowed_oauth_flows                 = ["code", "implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["openid", "email"]
 
  supported_identity_providers = ["COGNITO"]
 
  callback_urls = ["http://localhost:3000/callback"]
  logout_urls   = ["https://localhost.com/logout"]
 
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]
}
