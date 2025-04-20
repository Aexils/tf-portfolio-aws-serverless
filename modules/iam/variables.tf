variable "iam_user_name" {
  type = string
}

variable environment {
  type = string
}

variable github_actions_deploy_policy_name {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "cloudfront_distribution_arn" {
  type = string
  description = "L'arn de la distribution CloudFront"
}
