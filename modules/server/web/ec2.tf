# ========================================================== #
# [概要]
# EC2インスタンス構築
# ========================================================== #

resource "aws_instance" "server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  user_data = file("${path.module}/script.sh")

  # IAM Role
  iam_instance_profile = var.iam_instance_profile

  # EBSのルートボリューム設定
  root_block_device {
    # ボリュームサイズ(GiB)
    volume_size = var.volume_size
    # ボリュームタイプ
    volume_type = var.volume_type
    # GP3のIOPS
    iops = var.iops
    # GP3のスループット
    throughput = var.throughput
    # EC2終了時に削除
    delete_on_termination = var.delete_on_termination

    # EBSのNameタグ
    tags = {
      Name = var.root_block_device_tags_Name
    }
  }

  tags = {
    Env = var.tags_Env
    Name = var.tags_Name
  }
}