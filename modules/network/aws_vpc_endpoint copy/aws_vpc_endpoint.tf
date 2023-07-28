# ========================================================== #
# [処理名]
# VPC ENDPOINT構築
# 
# [概要]
# VPC ENDPOINT構築
#
# [引数]
# 変数名: u_vpc_ip_ip4
# 値: 10.0.0.0/16
# 
# 変数名: u_web_private_subnet_1a_id
# 値: WEBサーバ用プライベートサブネット(ap-northeast-1a)のIPアドレス
# 
# 変数名: u_vpc_endpoint_sg_id
# 値: VPCエンドポイント(Interface型)のセキュリティグループのID
# 
# 変数名: u_vpc_endpoint_route_table_id
# 値: VPCエンドポイント(Interface型)のルートテーブルのID
# 
# [output]
# なし
# ========================================================== #

data  "aws_iam_policy_document" "vpc_endpoint" {
  statement {
    effect    = "Allow"
    actions   = [ "*" ]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_endpoint_type = "Interface"
  vpc_id            =  var.u_vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    var.u_web_private_subnet_1a_id
  ]
  private_dns_enabled = true
  security_group_ids = [
    var.u_vpc_endpoint_sg_id
  ]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = var.u_vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    var.u_web_private_subnet_1a_id
  ]
  private_dns_enabled = true
  security_group_ids = [
    var.u_vpc_endpoint_sg_id
  ]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = var.u_vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    var.u_web_private_subnet_1a_id
  ]
  private_dns_enabled = true
  security_group_ids = [
    var.u_vpc_endpoint_sg_id
  ]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_endpoint_type = "Gateway"
  vpc_id            = var.u_vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  route_table_ids = [
    var.u_vpc_endpoint_route_table_id
  ]
}