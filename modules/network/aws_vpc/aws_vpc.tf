# ========================================================== #
# [概要]
# VPC構築
# ========================================================== #

resource "aws_vpc" "default" {
  # count = var.u_count
  cidr_block       = var.u_vpc_ip_ip4
  instance_tenancy = var.u_instance_tenancy
  enable_dns_support   = var.u_enable_dns_support 
  enable_dns_hostnames = var.u_enable_dns_hostnames 
  
  tags = {
    Env = var.u_env
    Name = var.u_name
  }

}

# output "vpc_id" {
#   # value = [ for value in aws_vpc.default : value.id ]
#   # 以下でもOK
#   value = "${aws_vpc.default.id}"
# }