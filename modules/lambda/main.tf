resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_logs" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "backend" {
  function_name = "${var.project_name}-${var.environment}-backend"
  handler       = "dist/lambda.handler"
  runtime       = "nodejs22.x"
  memory_size   = 512
  timeout       = 10
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      NODE_ENV           = var.environment
      USERS_TABLE_NAME   = var.users_table_name
      POSTS_TABLE_NAME   = var.posts_table_name
      JWT_SECRET         = var.jwt_secret
    }
  }
}

resource "aws_iam_policy" "lambda_dynamodb_access" {
  name = "${var.project_name}-${var.environment}-lambda-dynamodb-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AccessUsersTable",
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        Resource = "arn:aws:dynamodb:${var.region}:${var.aws_account_id}:table/${var.users_table_name}"
      },
      {
        Sid: "AccessPostsTable",
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Scan"
        ],
        Resource = "arn:aws:dynamodb:${var.region}:${var.aws_account_id}:table/${var.posts_table_name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_attach_dynamodb_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_access.arn
}

resource "aws_iam_role_policy" "lambda_ses_policy" {
  name = "allow-ses"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Resource = "*"
      }
    ]
  })
}
