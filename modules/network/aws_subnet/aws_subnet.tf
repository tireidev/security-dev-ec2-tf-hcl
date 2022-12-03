# ========================================================== #
# [処理名]
# Subnet構築
# 
# [概要]
# Subnet構築
#
# [引数]
# 変数名: u_vpc_id
# 値: VPCID
# 
# 変数名: u_web_private_subnet_1a_ip
# 値: WEBサーバ用プライベートサブネット(ap-northeast-1a)のIPアドレス
# 
# 変数名: u_db_private_subnet_1a_ip
# 値: DBサーバ用プライベートサブネット(ap-northeast-1a)のIPアドレス
# 
# 変数名: u_db_private_subnet_1c_ip
# 値: DBサーバ用プライベートサブネット(ap-northeast-1c)のIPアドレス
# 
# [output]
# 変数名: web_private_subnet_1a_id
# 値: WEBサーバ用プライベートサブネット(ap-northeast-1a)のID
#
# 変数名: db_private_subnet_1a_id
# 値: DBサーバ用プライベートサブネット(ap-northeast-1a)のID
#
# 変数名: db_private_subnet_1c_id
# 値: DBサーバ用プライベートサブネット(ap-northeast-1c)のID
#
# ========================================================== #

# ========================================================== #
#  プライベートサブネット作成
# ========================================================== #
resource "aws_subnet" "web_private_subnet_1a" {
  vpc_id = var.u_vpc_id
  cidr_block = var.u_web_private_subnet_1a_ip

  tags = {
    Env = "dev"
    Name = "web_private_subnet_1a"
  }
}

resource "aws_subnet" "db_private_subnet_1a" {
  vpc_id = var.u_vpc_id
  cidr_block = var.u_db_private_subnet_1a_ip

  tags = {
    Env = "dev"
    Name = "db_private_subnet_1a"
  }
}

resource "aws_subnet" "db_private_subnet_1c" {
  vpc_id = var.u_vpc_id
  cidr_block = var.u_db_private_subnet_1c_ip

  tags = {
    Env = "dev"
    Name = "db_private_subnet_1c"
  }
}

output "web_private_subnet_1a_id" {
  value = "${aws_subnet.web_private_subnet_1a.id}"
}

output "db_private_subnet_1a_id" {
  value = "${aws_subnet.db_private_subnet_1a.id}"
}

output "db_private_subnet_1c_id" {
  value = "${aws_subnet.db_private_subnet_1c.id}"
}