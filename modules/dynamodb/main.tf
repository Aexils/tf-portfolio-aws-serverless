resource "aws_dynamodb_table" "posts" {
  name           = var.posts_table_name
  billing_mode   = "PAY_PER_REQUEST" # Free Tier-compatible
  hash_key       = "PK"

  attribute {
    name = "PK"
    type = "S"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "users" {
  name           = var.users_table_name
  billing_mode   = "PAY_PER_REQUEST" # ✅ Free Tier et scalable
  hash_key       = "PK"

  attribute {
    name = "PK"
    type = "S"
  }

  tags = {
    Environment = var.environment
  }
}

