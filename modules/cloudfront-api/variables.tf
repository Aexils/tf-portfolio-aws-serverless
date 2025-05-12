variable "api_domain_name" {
  description = "Nom de domaine personnalisé pour l'API (ex: api.blog.aexils.ca)"
  type        = string
}

variable "environment" {
  description = "Nom de l'environnement (ex: dev, prod)"
  type        = string
}

variable "subject_alternative_names" {
  type = list(string)
}

variable "api_endpoint" {
  type = string
}