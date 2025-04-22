variable "domain" {
  description = "Nom de domaine à vérifier"
  type        = string
  default     = null
}

variable "email" {
  description = "Adresse email à vérifier"
  type        = string
  default     = null
}

variable "zone_id" {
  description = "ID de la zone Route 53"
  type        = string
}
