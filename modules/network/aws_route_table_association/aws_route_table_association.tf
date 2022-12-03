# ========================================================== #
# [処理名]
# RouteTableとSubnetの紐付け
# 
# [概要]
# RouteTableとSubnetの紐付け
#
# [引数]
# 変数名: u_aws_route_table_id
# 値: ルートテーブルID
# 
# 変数名: u_web_private_subnet_1a_id
# 値: WEBサーバ用プライベートサブネット(ap-northeast-1a)のIPアドレス
# 
# 変数名: u_db_private_subnet_1a_ip
# 値: DBサーバ用プライベートサブネット(ap-northeast-1a)のIPアドレス
# 
# 変数名: u_db_private_subnet_1c_ip
# 値: DBサーバ用プライベートサブネット(ap-northeast-1c)のIPアドレス
#
# [output]
# なし
#
# ========================================================== #

resource "aws_route_table_association" "private_rt_associate_web_1a" {
  route_table_id = var.u_aws_route_table_id
  subnet_id      = var.u_web_private_subnet_1a_id
}

resource "aws_route_table_association" "private_rt_associate_db_1a" {
  route_table_id = var.u_aws_route_table_id
  subnet_id      = var.u_db_private_subnet_1a_id
}

resource "aws_route_table_association" "private_rt_associate_db_1c" {
  route_table_id = var.u_aws_route_table_id
  subnet_id      = var.u_db_private_subnet_1c_id
}