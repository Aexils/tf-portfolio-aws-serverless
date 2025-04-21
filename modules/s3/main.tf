resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "frontend_bucket_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.frontend.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.frontend_bucket_policy.json
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "aexils-tf-state-prod"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "lambda_builds" {
  bucket        = "${var.project_name}-lambda-builds"
  force_destroy = true

  tags = {
    Name        = "${var.project_name}-lambda-builds"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "lambda_builds_block" {
  bucket = aws_s3_bucket.lambda_builds.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "lambda_builds_versioning" {
  bucket = aws_s3_bucket.lambda_builds.id

  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "lambda_builds_access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.lambda_builds.arn}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "lambda_builds_policy" {
  bucket = aws_s3_bucket.lambda_builds.id
  policy = data.aws_iam_policy_document.lambda_builds_access.json
}

resource "aws_s3_object" "lambda_placeholder" {
  bucket = aws_s3_bucket.lambda_builds.id
  key    = "lambda.zip"
  source = "${path.module}/lambda.zip"
  etag   = filemd5("${path.module}/lambda.zip")
}
