# ========================================================== #
# セキュリティグループ構築
# ========================================================== #

# ========================================================== #
#   VPCエンドポイントのセキュリティグループ
# ========================================================== #
resource "aws_security_group" "this" {
  name        = var.Name
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name = var.Name
    env = var.env
  }
  # インバウンドルールはaws_security_group_ruleにて定義
}

resource "aws_security_group_rule" "this" {
  type = lookup(var.rules,"type")
  from_port   = lookup(var.rules,"from_port")
  to_port     = lookup(var.rules,"to_port")
  protocol    = lookup(var.rules,"protocol")
  cidr_blocks = [lookup(var.rules,"cidr_blocks")]

  # セキュリティグループと紐付け
  security_group_id = "${aws_security_group.this.id}"
}

# VPCエンドポイントのセキュリティグループ
output "id" {
  value = "${aws_security_group.this.id}"
}

# ========================================================== #
#   EC2インスタンスのセキュリティグループ
# ========================================================== #
# resource "aws_security_group" "prj_dev_ec2_sg" {
#   name        = "prj_dev_ec2_sg"
#   description = "Allow all outbound traffic."
#   vpc_id      = var.vpc_id

#   tags = {
#     env = "dev"
#     Name = "prj_dev_ec2_sg"
#   }
#   # セキュリティルールはaws_security_group_ruleにて定義
# }

# アウトバウンドルールの全開放
# resource "aws_security_group_rule" "all_outbound" {
#   type        = "egress"
#   from_port   = 0
#   to_port     = 0
#   protocol    = "-1"
#   cidr_blocks = ["0.0.0.0/0"]

#   # セキュリティグループと紐付け
#   security_group_id = "${aws_security_group.prj_dev_ec2_sg.id}"
# }

# EC2インスタンスのセキュリティグループ
# output "prj_dev_ec2_sg_id" {
#   value = "${aws_security_group.prj_dev_ec2_sg.id}"
# }

# ========================================================== #
#   RDSのセキュリティグループ
# ========================================================== #
# resource "aws_security_group" "prj_dev_db_sg" {
#   name        = "prj_dev_db_sg"
#   description = "Allow traffic."
#   vpc_id      = var.vpc_id

#   tags = {
#     env = "dev"
#     Name = "prj_dev_db_sg"
#   }
#   # インバウンドルールはaws_security_group_ruleにて定義
# }

# 5432番ポート許可のインバウンドルール
# resource "aws_security_group_rule" "ingress_allow_5432" {
#   type        = "ingress"
#   from_port   = 5432
#   to_port     = 5432
#   protocol    = "tcp"
#   # cidr_blocks = ["10.0.0.0/16"]
#   source_security_group_id  = aws_security_group.prj_dev_ec2_sg.id

#   # セキュリティグループと紐付け
#   security_group_id = "${aws_security_group.prj_dev_db_sg.id}"
# }

# RDSのセキュリティグループ
# output "prj_dev_db_sg_id" {
#   value = "${aws_security_group.prj_dev_db_sg.id}"
# }