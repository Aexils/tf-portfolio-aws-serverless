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
    aws = aws
  }
}

module "s3" {
  source = "../../modules/s3"

  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  environment                 = var.environment
  bucket_name                 = "aexils-frontend-prod"
  project_name                = var.project_name
}

module "iam-github-actions" {
  source = "../../modules/iam"

  bucket_name                       = module.s3.bucket_name
  cloudfront_distribution_arn       = module.cloudfront.cloudfront_distribution_arn
  iam_user_name                     = "github-actions-deploy"
  environment                       = var.environment
  github_actions_deploy_policy_name = "github-actions-deploy-policy"
}

module "lambda" {
  source = "../../modules/lambda"

  project_name = "aexils"
  environment  = var.environment

  aws_account_id = var.aws_account_id
  region         = var.aws_region

  users_table_name = module.dynamodb.users_table_name
  posts_table_name = module.dynamodb.posts_table_name

  jwt_secret = "changeme"

  ecr_repository_url = module.ecr.repository_url
}

module "dynamodb" {
  source = "../../modules/dynamodb"

  posts_table_name = "posts"
  users_table_name = "users"
  environment      = var.environment
}

module "api_gateway" {
  source = "../../modules/api-gateway"

  project_name              = var.project_name
  environment               = var.environment
  lambda_arn                = module.lambda.lambda_arn
}

module "ecr" {
  source = "../../modules/ecr"

  environment = var.environment
}

data "aws_route53_zone" "selected" {
  name = "aexils.ca."
}

module "ses" {
  source = "../../modules/ses"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  domain  = "aexils.ca"
  email   = "noreply@aexils.ca"
  zone_id = data.aws_route53_zone.selected.zone_id
}

module "cloudfront-api" {
  source = "../../modules/cloudfront-api"

  api_domain_name = var.api_domain_name
  api_endpoint = module.api_gateway.api_endpoint
  environment = var.environment
  subject_alternative_names = [var.api_domain_name]

  providers = {
    aws            = aws
    aws.ca_central = aws.ca_central
    aws.us_east_1  = aws.us_east_1
  }
}


