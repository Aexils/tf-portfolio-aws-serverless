resource "aws_ecr_repository" "lambda_backend" {
  name = "aexils-backend"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}
