output "domain_identity_arn" {
  value = aws_ses_domain_identity.domain.arn
}

output "email_identity" {
  value = aws_ses_email_identity.noreply.email
}
