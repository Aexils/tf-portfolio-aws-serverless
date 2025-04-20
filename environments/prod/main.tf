terraform {
  backend "s3" {
    bucket = "aexils-tf-state-prod"
    key    = "environments/prod/terraform.tfstate"
    region = "ca-central-1"
  }
}

module "cloudfront" {
  source = "../../modules/cloudfront"

  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  environment               = var.environment
  oac_name                  = "cloudfront_oac"
  bucket_domain_name        = module.s3.bucket_domain_name
  bucket_name               = module.s3.bucket_name
  providers = {
    aws           = aws
  }
}

module "s3" {
  source = "../../modules/s3"

  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  environment     = var.environment
  bucket_name     = "aexils-frontend-prod"
  project_name = var.project_name
}

module "iam-github-actions" {
  source = "../../modules/iam"

  bucket_name = module.s3.bucket_name
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  iam_user_name = "github-actions-deploy"
  environment = var.environment
  github_actions_deploy_policy_name = "github-actions-deploy-policy"
}

module "lambda" {
  source = "../../modules/lambda"

  project_name    = "aexils"
  environment     = var.environment
  lambda_zip_path = "${path.module}/lambda.zip"

  environment_variables = {
    NODE_ENV           = var.environment
    USERS_TABLE_NAME   = module.dynamodb.users_table_name
    POSTS_TABLE_NAME   = module.dynamodb.posts_table_name
    MAIL_FROM  = "noreply@aexils.ca"
  }

  aws_account_id   = var.aws_account_id
  region           = var.aws_region

  users_table_name = module.dynamodb.users_table_name
  posts_table_name = module.dynamodb.posts_table_name
  jwt_secret       = ""
}

module "dynamodb" {
  source            = "../../modules/dynamodb"

  posts_table_name = "posts"
  users_table_name  = "users"
  environment       = var.environment
}

module "api_gateway" {
  source        = "../../modules/api-gateway"
  project_name  = var.project_name
  environment   = var.environment
  lambda_arn    = module.lambda.lambda_arn
}


