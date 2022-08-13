# ========================================================== #
# [処理名]
# EC2インスタンス構築
# 
# [概要]
# EC2インスタンス構築
#
# [引数]
# 変数名: u_private_subnet_id
# 値: プライベートサブネットID
# 
# 変数名: u_ec2_sg_id
# 値: セキュリティグループID
# 
# 変数名: u_key_name
# 値: プライベートキー名
# 
# [output]
# なし
#
# ========================================================== #

resource "aws_instance" "server" {
  ami                    = "ami-00d101850e971728d"
  instance_type          = "t2.micro"
  subnet_id              = var.u_private_subnet_id
  vpc_security_group_ids = [var.u_ec2_sg_id]
  key_name               = var.u_key_name
  user_data = file("${path.module}/script.sh")

  # IAM Role
  iam_instance_profile = "EC2RoleforSSM"

  # EBSのルートボリューム設定
  root_block_device {
    # ボリュームサイズ(GiB)
    volume_size = 8
    # ボリュームタイプ
    volume_type = "gp3"
    # GP3のIOPS
    iops = 3000
    # GP3のスループット
    throughput = 125
    # EC2終了時に削除
    delete_on_termination = true

    # EBSのNameタグ
    tags = {
      Name = "server_ebs"
    }
  }

  tags = {
    Env = "dev"
    Name = "server"
  }
}