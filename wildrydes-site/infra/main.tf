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
      baseDirectory: .
      files:
        - '**/*'
    cache:
      paths: []
YAML
    environment_variables = {
    ENV = "prod"
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