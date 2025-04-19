variable "environment" {
  type    = string
}

variable "bucket_name" {
  type    = string
}

variable "cloudfront_distribution_arn" {
  description     = "ARN de la distribution CloudFront (ex: arn:aws:cloudfront::123456789012:distribution/EXAMPLE)"
  type            = string
}
