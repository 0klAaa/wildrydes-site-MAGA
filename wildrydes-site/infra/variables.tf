variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "site_bucket_name" {
  type = string
  default = "magabuckets3"
}

variable "project_name" {
  type    = string
  default = "maga-wildrydes"
}

variable "cognito_domain_prefix" {
  type = string
  default = "maga-wildrydes-auth-001"
}

variable "cognito_callback_url" {
  type = string
  default = "https://d2gw4h3g14s8co.cloudfront.net/signin.html"
}

variable "cognito_logout_url" {
  type = string
  default = "https://d2gw4h3g14s8co.cloudfront.net/"
}

variable "github_owner" { type = string }
variable "github_repo"  { type = string }
