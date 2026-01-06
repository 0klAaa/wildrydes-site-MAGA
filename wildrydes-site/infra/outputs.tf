output "bucket_name" {
  value = aws_s3_bucket.site.bucket
}

output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}

variable "bucket_name" {
  type = string
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.wildrydes.id
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.wildrydes.id
}

output "cognito_domain" {
  value = "${aws_cognito_user_pool_domain.wildrydes.domain}.auth.${var.aws_region}.amazoncognito.com"
}

output "api_invoke_url" {
  value = "${aws_apigatewayv2_stage.prod.invoke_url}"
}