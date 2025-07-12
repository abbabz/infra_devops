variable "key_name" {
  default = "my-key"
}

variable "public_key_path" {
  description = "Chemin vers le fichier de clé publique SSH"
  type        = string
}
