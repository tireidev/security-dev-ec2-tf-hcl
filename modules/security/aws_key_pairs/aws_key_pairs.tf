# ========================================================== #
# [処理名]
# キーペア構築
# 
# [概要]
# EC2インスタンスのSSH接続で利用するためのキーペアを作成する
#
# [引数]
# 変数名: u_key_name
# 値: AWSに登録するためのキーペアの名前
# 
# 変数名: u_public_key_name
# 値: パブリックキー名
# 
# 変数名: u_private_key_name
# 値: プライベートキー名
# 
# [output]
# key_name: AWSに登録するためのキーペアの名前
#
# ========================================================== #

resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.u_key_name
  public_key = tls_private_key.keygen.public_key_openssh
}

resource "local_sensitive_file" "keypair_pem" {
  filename        = "${var.u_private_key_name}"
  content         = tls_private_key.keygen.private_key_pem
  file_permission = "0600"
}

resource "local_sensitive_file" "keypair_pub" {
  filename        = "${var.u_public_key_name}"
  content         = tls_private_key.keygen.public_key_openssh
  file_permission = "0600"
}

output "key_name" {
  value = "${aws_key_pair.key_pair.key_name}"
}