output "cloudfront_oac_id" {
  description = "L'identifiant de l'OAC à utiliser dans S3 bucket policy"
  value       = aws_cloudfront_origin_access_control.cloudfront_oac.id
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}


output "domain_validation_options" {
  value     = aws_acm_certificate.acm_certificate.domain_validation_options
}

output "certificat_acm" {
  value = aws_acm_certificate.acm_certificate.arn
}