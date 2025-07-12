# variables.tf

variable "key_name" {
  description = "Nom de la clé SSH utilisée pour la connexion EC2"
  type        = string
}

variable "public_key" {
  description = "Contenu de la clé publique SSH"
  type        = string
}
