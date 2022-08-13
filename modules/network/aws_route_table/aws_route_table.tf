# ========================================================== #
# [処理名]
# Route table構築
# 
# [概要]
# Route table構築
#
# [引数]
# 変数名: u_vpc_id
# 値: VPCID
# 
# [output]
# 変数名: id
# 値: Route Table ID
# ========================================================== #

# ========================================================== #
#  Route table作成
# ========================================================== #
resource "aws_route_table" "prj_dev_route_table" {
  vpc_id = var.u_vpc_id
  tags = {
    Env = "dev"
    Name = "prj_dev_route_table"
  }
}

output "id" {
  value = "${aws_route_table.prj_dev_route_table.id}"
}