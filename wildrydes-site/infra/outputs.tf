output "amplify_default_domain" {
  value = aws_amplify_app.wildrydes.default_domain
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.wildrydes.id
}

output "aws_cognito_user_pool_client" {
  value = aws_cognito_user_pool_client.webapp.id
}