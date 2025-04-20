variable "environment" {
  type = string
  default = "prod"
}

variable "posts_table_name" {
  type = string
  description = "Nom de la table DynamoDB des posts"
}

variable "users_table_name" {
  type        = string
  description = "Nom de la table DynamoDB des utilisateurs"
}
