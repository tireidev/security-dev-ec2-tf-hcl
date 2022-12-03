# ========================================================== #
# [処理名]
# RDSインスタンス構築
# 
# [概要]
# RDSインスタンス構築
#
# [引数]
# 変数名: u_db_private_subnet_1a_ip
# 値: DBサーバ用プライベートサブネット(ap-northeast-1a)のIPアドレス
# 
# 変数名: u_db_private_subnet_1c_ip
# 値: DBサーバ用プライベートサブネット(ap-northeast-1c)のIPアドレス
# 
# 変数名: u_db_sg_id
# 値: RDSインスタンスのセキュリティグループのID
#
# [output]
# なし
#
# ========================================================== #

resource "aws_db_subnet_group" "praivate-db" {
    name        = "praivate-db"
    subnet_ids  = ["${var.u_db_private_subnet_1a_id}", "${var.u_db_private_subnet_1c_id}"]
    tags = {
        Name = "praivate-db"
    }
}

resource "aws_db_instance" "test_db_postgresql" {
  identifier           = "test-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "14.5"
  instance_class       = "db.t4g.micro"
  db_name                 = "test_db_postgresql"
  username             = "test"
  password             = "postgresql"
  vpc_security_group_ids  = ["${var.u_db_sg_id}"]
  db_subnet_group_name = "${aws_db_subnet_group.praivate-db.name}"
  skip_final_snapshot = true
}