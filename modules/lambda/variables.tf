variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "lambda_zip_path" {
  type = string
}

variable "environment_variables" {
  type = map(string)
}

variable "aws_account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "users_table_name" {
  type = string
}

variable "posts_table_name" {
  type = string
}

variable "jwt_secret" {
  type = string
}
