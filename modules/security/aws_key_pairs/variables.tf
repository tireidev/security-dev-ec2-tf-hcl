variable "algorithm" {
  type = string
  description = "tls_private_key algorithm"
  default = "RSA"
}

variable "rsa_bits" {
  type = number
  description = "tls_private_key rsa_bits"
  default = 4096
}

variable "key_name" {
    type = string
}
variable "private_key_name" {
    type = string
}
variable "public_key_name" {
    type = string
}
variable "file_permission" {
    type = string
}