# ========================================================== #
# Route table構築
# ========================================================== #
resource "aws_route_table" "prj_dev_route_table" {
  vpc_id = var.vpc_id
  tags = {
    env = var.env
    Name = var.Name
  }
}

