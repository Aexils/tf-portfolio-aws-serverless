variable "domain_name" {
  type    = string
}

variable "subject_alternative_names" {
  type    = list(string)
}

variable "bucket_domain_name" {
  type    = string
}

variable "bucket_name" {
  type    = string
}

variable "environment" {
  type    = string
}

variable "oac_name" {
  type    = string
}