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