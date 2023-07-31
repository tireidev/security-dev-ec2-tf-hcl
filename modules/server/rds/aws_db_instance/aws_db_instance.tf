# ========================================================== #
# [概要]
# RDSインスタンス構築
# ========================================================== #
resource "aws_db_instance" "this" {
  identifier           = var.identifier
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name                 = var.db_name
  username             = var.username
  password             = var.password
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name = var.db_subnet_group_name
  skip_final_snapshot = var.skip_final_snapshot
}