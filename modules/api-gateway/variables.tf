variable "lambda_arn" {
  description = "ARN de la Lambda à intégrer"
  type        = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "subject_alternative_names" {
  type = list(string)
}

variable "api_domain_name" {
  type = string
}