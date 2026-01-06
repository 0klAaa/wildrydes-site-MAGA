resource "aws_cognito_user_pool" "wildrydes" {
  name = "${var.project_name}-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = false
  }
}

resource "aws_cognito_user_pool_client" "wildrydes" {
  name         = "${var.project_name}-app-client"
  user_pool_id = aws_cognito_user_pool.wildrydes.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

  callback_urls = [var.cognito_callback_url]
  logout_urls   = [var.cognito_logout_url]

  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "wildrydes" {
  domain       = var.cognito_domain_prefix
  user_pool_id = aws_cognito_user_pool.wildrydes.id
}