terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "acm_certificate" {
  provider                        = aws.us_east_1
  domain_name                     = var.domain_name
  validation_method               = "DNS"
  subject_alternative_names       = var.subject_alternative_names

  tags = {
    Environment                   = var.environment
  }
}

resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = var.oac_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"

}

data "aws_route53_zone" "selected" {
  name         = "aexils.ca."
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [aws_acm_certificate_validation.cert_validation]

  origin {
    domain_name              = var.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac.id
    origin_id                = var.bucket_name
  }

  enabled             = true
  comment             = "Cloudfront for Angular SPA with routing"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"
  aliases             = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.rewrite_index_html.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.acm_certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_record" "cloudfront_alias" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "blog"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_function" "rewrite_index_html" {
  name    = "angular-routing-rewrite"
  runtime = "cloudfront-js-1.0"
  comment = "Rewrite all SPA routes to index.html"

  code = <<EOF
    function handler(event) {
      var request = event.request;
      var uri = request.uri;

      if (!uri.includes('.') && !uri.endsWith('/')) {
        request.uri = '/index.html';
      }

      return request;
    }
  EOF
}
