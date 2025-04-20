output "bucket_name" {
  value = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  value = aws_s3_bucket.frontend.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.frontend.bucket_regional_domain_name
}

output "lambda_builds_bucket" {
  value = aws_s3_bucket.lambda_builds.bucket
}
