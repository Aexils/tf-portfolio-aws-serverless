terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ca-central-1"
}

# Email à vérifier (from)
resource "aws_ses_email_identity" "noreply" {
  email = "noreply@aexils.ca"
}

# Domaine principal à vérifier
resource "aws_ses_domain_identity" "domain" {
  domain = "aexils.ca"
}

# Record DNS pour valider le domaine dans Route 53
data "aws_route53_zone" "main" {
  name = "aexils.ca."
}

resource "aws_route53_record" "ses_verification" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.domain.domain}"
  type    = "TXT"
  ttl     = 300
  records = [aws_ses_domain_identity.domain.verification_token]
}

# Étape de vérification (attend que le DNS soit propagé)
resource "aws_ses_domain_identity_verification" "verify" {
  domain     = aws_ses_domain_identity.domain.domain
  depends_on = [aws_route53_record.ses_verification]
}
