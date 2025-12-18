resource "aws_amplify_app" "wildrydes" {
  name       = "MAGA-wildrydes-site-Terraform"
  repository = var.github_repo_url
  oauth_token = var.github_token
  iam_service_role_arn = aws_iam_role.MagaIAM.arn
  
  build_spec = <<-YAML
  version: 1
  frontend:
    phases:
      build:
        commands:
          - echo "Hello"
    artifacts:
      baseDirectory: wildrydes-site
      files:
        - '**/*'
    cache:
      paths: []
YAML

custom_rule {
    source = "/"
    target = "/index.html"
    status = "200"
  }
    environment_variables = {
    ENV = "prod"
  }
  lifecycle {
  ignore_changes = [oauth_token]
}
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.wildrydes.id
  branch_name = var.github_branch

  enable_auto_build = true
}

resource "aws_iam_role" "MagaIAM" {
  name = "MagaIAM"
  
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["amplify.eu-west-1.amazonaws.com","amplify.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_cognito_user_pool" "wildrydes" {
  name = "WildRydes"

  auto_verified_attributes = ["email"]
  username_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }
}

resource "aws_cognito_user_pool_client" "webapp" {
  name         = "WildRydesWebApp"
  user_pool_id = aws_cognito_user_pool.wildrydes.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]

  supported_identity_providers = ["COGNITO"]
}