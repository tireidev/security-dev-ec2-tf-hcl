
resource "tls_private_key" "keygen" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.keygen.public_key_openssh
}

resource "local_sensitive_file" "keypair_pem" {
  filename        = var.private_key_name
  content         = tls_private_key.keygen.private_key_pem
  file_permission = var.file_permission
}

resource "local_sensitive_file" "keypair_pub" {
  filename        = var.public_key_name
  content         = tls_private_key.keygen.public_key_openssh
  file_permission = var.file_permission
}

output "key_name" {
  value = aws_key_pair.key_pair.key_name
}