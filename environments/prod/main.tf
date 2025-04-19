module "cloudfront" {
  source = "../../modules/cloudfront"

  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  environment               = var.environment
  oac_name                  = "cloudfront_oac"
  bucket_domain_name        = module.s3-frontend.bucket_domain_name
  bucket_name               = module.s3-frontend.bucket_name
  providers = {
    aws           = aws
  }
}

module "s3-frontend" {
  source = "../../modules/s3-frontend"

  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  environment     = var.environment
  bucket_name     = "aexils-frontend-prod"
}

module "iam-github-actions" {
  source = "../../modules/iam-github-actions"

  bucket_name = module.s3-frontend.bucket_name
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  iam_user_name = "github-actions-deploy"
  environment = var.environment
  github_actions_deploy_policy_name = "github-actions-deploy-policy"
}
