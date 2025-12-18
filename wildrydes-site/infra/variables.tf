variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_repo_url" {
  type = string
  default = "https://github.com/0klAaa/wildrydes-site-MAGA/"
}

variable "github_branch" {
  type    = string
  default = "main"
}