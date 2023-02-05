# ========================================================== #
# VPC構築
# ========================================================== #
resource "aws_vpc" "default" {
  # count = var.u_count
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support 
  enable_dns_hostnames = var.enable_dns_hostnames 
  
  tags = {
    env = var.env
    Name = var.Name
  }

}