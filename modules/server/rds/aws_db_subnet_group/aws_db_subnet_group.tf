# ========================================================== #
# [概要]
# RDSサブネットグループ構築
# ========================================================== #
resource "aws_db_subnet_group" "praivate-db" {
    name        = var.name
    subnet_ids  = var.subnet_ids
    tags = {
        Name = var.name
    }
}