# ========================================================== #
# [処理名]
# セキュリティグループ構築
# 
# [概要]
# セキュリティグループ構築
# ・インバウンドルール
#    接続元:MyIP
#    ポート:443(TCP)
#
# [引数]
# 変数名: u_vpc_id
# 値: VPCID
# 
# [output]
# 変数名: prj_dev_vpc_endpoint_sg_id
# 値: VPCエンドポイントのセキュリティグループ
#
# 変数名: prj_dev_ec2_sg_id
# 値: EC2インスタンスのセキュリティグループ
# ========================================================== #

# ========================================================== #
#   VPCエンドポイントのセキュリティグループ
# ========================================================== #
resource "aws_security_group" "prj_dev_vpc_endpoint_sg" {
  name        = "prj_dev_vpc_endpoint_sg"
  description = "Allow https traffic."
  vpc_id      = var.u_vpc_id

  tags = {
    Env = "dev"
    Name = "prj_dev_vpc_endpoint_sg"
  }
  # インバウンドルールはaws_security_group_ruleにて定義
}

# 443番ポート許可のインバウンドルール
resource "aws_security_group_rule" "ingress_allow_443" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_vpc_endpoint_sg.id}"
}

# VPCエンドポイントのセキュリティグループ
output "prj_dev_vpc_endpoint_sg_id" {
  value = "${aws_security_group.prj_dev_vpc_endpoint_sg.id}"
}

# ========================================================== #
#   EC2インスタンスのセキュリティグループ
# ========================================================== #
resource "aws_security_group" "prj_dev_ec2_sg" {
  name        = "prj_dev_ec2_sg"
  description = "Allow all outbound traffic."
  vpc_id      = var.u_vpc_id

  tags = {
    Env = "dev"
    Name = "prj_dev_ec2_sg"
  }
  # セキュリティルールはaws_security_group_ruleにて定義
}

# アウトバウンドルールの全開放
resource "aws_security_group_rule" "all_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.prj_dev_ec2_sg.id}"
}

# EC2インスタンスのセキュリティグループ
output "prj_dev_ec2_sg_id" {
  value = "${aws_security_group.prj_dev_ec2_sg.id}"
}