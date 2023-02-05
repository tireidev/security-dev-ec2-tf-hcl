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
#   2.4. キーペア構築 ※EC2インスタンスにローカルマシンにてSSH接続でするため
# 3. EC2インスタンス構築
# 4. RDSインスタンス構築
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
  source               = "./modules/network/aws_vpc"
  for_each             = var.vpc_setting
  Name                 = each.value.Name
  env                  = each.value.env
  cidr_block           = each.value.cidr
  instance_tenancy     = each.value.instance_tenancy
  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames
}

# ========================================================== #
#   1.2. RouteTable構築
# ========================================================== #
module "aws_route_table" {
  source   = "./modules/network/aws_route_table"
  for_each = var.route_tables
  Name     = each.value.Name
  env      = each.value.env
  vpc_id   = module.aws_vpc["${each.value.vpc_name}"].vpc_id
}

# ========================================================== #
#   1.3. Subnet構築
# ========================================================== #
module "aws_subnet" {
  source     = "./modules/network/aws_subnet"
  for_each   = var.subnets
  vpc_id     = module.aws_vpc["prj-prd-vpc"].vpc_id
  cidr_block = each.value.cidr_block
  env        = each.value.env
  Name       = each.value.Name
}

# ========================================================== #
#   1.4. RouteTableとPublic Subnetの紐付け
# ========================================================== #
module "aws_route_table_association_web" {
  source         = "./modules/network/aws_route_table_association"
  route_table_id = module.aws_route_table["prj-prd-web-route_table"].id
  subnet_id      = module.aws_subnet["prj-prd-web-subnet-1a"].id
}

locals {
  db-subnets-id = {
    db-subnets-1a = module.aws_subnet["prj-prd-db-subnet-1a"].id,
    db-subnets-1c = module.aws_subnet["prj-prd-db-subnet-1c"].id
  }
}
module "aws_route_table_association_db" {
  source         = "./modules/network/aws_route_table_association"
  for_each = local.db-subnets-id
  route_table_id = module.aws_route_table["prj-prd-db-route_table"].id
  subnet_id = each.value
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
  vpc_id     = module.aws_vpc["prj-prd-vpc"].vpc_id
  for_each = var.aws_security_groups
  Name = each.value.Name
  description = each.value.description
  env = each.value.env
  rules = each.value.rules
}

# ========================================================== #
#   2.3. VPCエンドポイント構築
# ========================================================== #
# module "aws_vpc_endpoint" {
#   source                        = "./modules/network/aws_vpc_endpoint"
#   u_vpc_id                      = module.aws_vpc["prj-prd-vpc"].vpc_id
#   u_web_private_subnet_1a_id    = module.aws_subnet.web_private_subnet_1a_id
#   u_vpc_endpoint_sg_id          = module.aws_security_group.prj_dev_vpc_endpoint_sg_id
#   u_vpc_endpoint_route_table_id = module.aws_route_table["prj-prd-web-route_table"].id
# }

# ========================================================== #
#   2.4. キーペア構築 ※EC2インスタンスにローカルマシンにてSSH接続でするため
# ========================================================== #
# module "aws_key_pairs" {
#   source             = "./modules/security/aws_key_pairs"
#   u_key_name         = var.u_key_name
#   u_private_key_name = var.u_private_key_name
#   u_public_key_name  = var.u_public_key_name
# }

# ========================================================== #
# 3. EC2インスタンス構築
# ========================================================== #
# module "ec2" {
#   source                     = "./modules/server/web"
#   u_web_private_subnet_1a_id = module.aws_subnet.web_private_subnet_1a_id
#   u_ec2_sg_id                = module.aws_security_group.prj_dev_ec2_sg_id
#   u_key_name                 = module.aws_key_pairs.key_name
# }

# ========================================================== #
# 4. RDSインスタンス構築
# ========================================================== #
# module "rds" {
#   source                  = "./modules/server/db"
#   u_db_private_subnet_1a_id     = module.aws_subnet.db_private_subnet_1a_id
#   u_db_private_subnet_1c_id     = module.aws_subnet.db_private_subnet_1c_id
#   u_db_sg_id             = module.aws_security_group.prj_dev_db_sg_id
# }