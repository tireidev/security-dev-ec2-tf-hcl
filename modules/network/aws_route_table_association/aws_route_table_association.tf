# ========================================================== #
# RouteTableとSubnetの紐付け
# ========================================================== #

resource "aws_route_table_association" "this" {
  route_table_id = var.route_table_id
  subnet_id      = var.subnet_id
}

# resource "aws_route_table_association" "private_rt_associate_db_1a" {
#   route_table_id = var.u_aws_route_table_id
#   subnet_id      = var.u_db_private_subnet_1a_id
# }

# resource "aws_route_table_association" "private_rt_associate_db_1c" {
#   route_table_id = var.u_aws_route_table_id
#   subnet_id      = var.u_db_private_subnet_1c_id
# }