terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

# Email à vérifier (from)
resource "aws_ses_email_identity" "noreply" {
  provider = aws.us_east_1
  email    = var.email
}

# Domaine principal à vérifier
resource "aws_ses_domain_identity" "domain" {
  provider = aws.us_east_1
  domain   = var.domain
}

# Record DNS pour valider le domaine dans Route 53
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

# Étape de vérification (attend que le DNS soit propagé)
resource "aws_ses_domain_identity_verification" "verify" {
  provider   = aws.us_east_1
  domain     = aws_ses_domain_identity.domain.domain
  depends_on = [aws_route53_record.ses_verification]
}
