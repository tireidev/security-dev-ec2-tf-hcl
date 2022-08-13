# ========================================================== #
# [処理名]
# RouteTableとSubnetの紐付け
# 
# [概要]
# RouteTableとprivate Subnetの紐付け
#
# [引数]
# 変数名: u_aws_route_table_id
# 値: ルートテーブルID
# 
# 変数名: u_private_subnet_ip
# 値: プライベートサブネットIPアドレス
# 
# [output]
# なし
#
# ========================================================== #

resource "aws_route_table_association" "private_rt_associate" {
  route_table_id = var.u_aws_route_table_id
  subnet_id      = var.u_private_subnet_id
}