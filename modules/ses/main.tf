terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws.ca]
    }
  }
}

provider "aws" {
  alias  = "ca"
  region = "ca-central-1"
}

resource "aws_ses_email_identity" "noreply" {
  provider = aws.ca
  email    = var.email
}

resource "aws_ses_domain_identity" "domain" {
  provider = aws.ca
  domain   = var.domain
}

data "aws_route53_zone" "main" {
  name = "${var.domain}."
}

resource "aws_route53_record" "ses_verification" {
  zone_id = var.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.domain.domain}"
  type    = "TXT"
  ttl     = 300
  records = [aws_ses_domain_identity.domain.verification_token]
}
