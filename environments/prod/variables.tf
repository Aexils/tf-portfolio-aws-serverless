variable "environment" {
  description = "The environment (e.g. dev, prod)"
  type        = string
}

variable "domain_name" {
  type = string
}

variable "api_domain_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}
variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}