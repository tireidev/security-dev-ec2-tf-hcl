# ========================================================== #
# [処理名]
# メイン処理
# 
# [概要]
# AWS上のセキュアな検証環境を構築する
# この検証環境はAWS Systems ManagerのSession Managerを利用して接続する
# 
# [手順]
# 0. プロバイダ設定(AWS)
# 1. ネットワーク構築
#   1.1. VPC構築
#   1.2. RouteTable構築
#   1.3. Subnet構築
#   1.4. RouteTableとPublic Subnetの紐付け
# 2. セキュリティ設定
#   2.1. IAM作成
#   2.2. セキュリティグループ構築
#   2.3. キーペア構築 ※EC2インスタンスのSSH接続で利用するため
# 3. EC2インスタンス構築
# ========================================================== #

# ========================================================== #
# 0. プロバイダ設定(AWS)
# ========================================================== #
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
}

provider "aws" {
  region = var.u_aws_region
}

# ========================================================== #
# 1. ネットワーク構築
# ========================================================== #
#   1.1. VPC構築
# ========================================================== #
module "aws_vpc" {
  u_vpc_ip_ip4 = var.u_aws_vpc_cidr
  source       = "./modules/network/aws_vpc"
}

# ========================================================== #
#   1.2. RouteTable構築
# ========================================================== #
module "aws_route_table" {
  u_vpc_id = module.aws_vpc.id
  source   = "./modules/network/aws_route_table"
}

# ========================================================== #
#   1.3. Subnet構築
# ========================================================== #
module "aws_subnet" {
  u_vpc_id            = module.aws_vpc.id
  u_private_subnet_ip = var.u_private_subnet_ip
  source              = "./modules/network/aws_subnet"
}

# ========================================================== #
#   1.4. RouteTableとPublic Subnetの紐付け
# ========================================================== #
module "aws_route_table_association" {
  u_aws_route_table_id = module.aws_route_table.id
  u_private_subnet_id  = module.aws_subnet.private_subnet_id
  source               = "./modules/network/aws_route_table_association"
}

# ========================================================== #
# 2. セキュリティ設定
# ========================================================== #
#   2.1. IAM作成
# ========================================================== #
module "aws_iam" {
  source = "./modules/security/aws_iam"
}

# ========================================================== #
#   2.2. セキュリティグループ構築
# ========================================================== #
module "aws_security_group" {
  source   = "./modules/security/aws_security_group"
  u_vpc_id = module.aws_vpc.id
}

# ========================================================== #
#   2.3. VPCエンドポイント構築
# ========================================================== #
module "aws_vpc_endpoint" {
  source                        = "./modules/network/aws_vpc_endpoint"
  u_vpc_id                      = module.aws_vpc.id
  u_private_subnet_id           = module.aws_subnet.private_subnet_id
  u_vpc_endpoint_sg_id          = module.aws_security_group.prj_dev_vpc_endpoint_sg_id
  u_vpc_endpoint_route_table_id = module.aws_route_table.id
}

# ========================================================== #
#   2.4. キーペア構築 ※EC2インスタンスにローカルマシンにてSSH接続でするため
# ========================================================== #
module "aws_key_pairs" {
  source             = "./modules/security/aws_key_pairs"
  u_key_name         = var.u_key_name
  u_private_key_name = var.u_private_key_name
  u_public_key_name  = var.u_public_key_name
}

# ========================================================== #
# 3. EC2インスタンス構築
# ========================================================== #
module "ec2" {
  source                  = "./modules/server"
  u_private_subnet_id     = module.aws_subnet.private_subnet_id
  u_ec2_sg_id             = module.aws_security_group.prj_dev_ec2_sg_id
  u_key_name              = module.aws_key_pairs.key_name
}