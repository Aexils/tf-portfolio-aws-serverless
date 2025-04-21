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

variable "lambda_s3_bucket" {
  description = "Nom du bucket S3 contenant le .zip Lambda"
  type        = string
}

variable "lambda_s3_key" {
  description = "Nom du fichier .zip Lambda dans le bucket S3"
  type        = string
}
