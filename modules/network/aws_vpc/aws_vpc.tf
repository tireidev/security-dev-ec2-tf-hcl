# ========================================================== #
# [処理名]
# VPC構築
# 
# [概要]
# VPC構築
#
# [引数]
# 変数名: u_vpc_ip_ip4
# 値: 10.0.0.0/16
# 
# [output]
# 変数名: id
# 値: VPCID
# ========================================================== #

resource "aws_vpc" "default" {
  cidr_block       = var.u_vpc_ip_ip4
  instance_tenancy = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Env = "dev"
    Name = "prj_dev_vpc"
  }

}

output "id" {
  value = "${aws_vpc.default.id}"
}