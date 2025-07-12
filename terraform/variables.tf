
variable "key_name" {
  description = "Nom de la clé SSH"
  type        = string
  default     = "my-key"
}

variable "public_key" {
  description = "Clé publique SSH en contenu string"
  type        = string
}
