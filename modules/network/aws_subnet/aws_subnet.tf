# ========================================================== #
#  サブネット作成 
# ========================================================== #
resource "aws_subnet" "this" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr_block

  tags = {
    env = var.env
    Name = var.Name
  }
}

output "id" {
  value = "${aws_subnet.this.id}"
}
