resource "aws_amplify_app" "wildrydes" {
  name       = "MAGA-wildrydes-site-Terraform"
  repository = var.github_repo_url
  access_token = var.github_token
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