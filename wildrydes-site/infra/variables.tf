variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "github_token" {
  type      = string
  sensitive = true
  default = "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"
}

variable "github_repo_url" {
  type = string
  default = "https://github.com/0klAaa/wildrydes-site-MAGA/"
}

variable "github_branch" {
  type    = string
  default = "main"
}