variable "key_name" {
  default = "my-key"
}

variable "public_key" {
  description = "Chemin vers le fichier de clé publique SSH"
  type        = string
}
