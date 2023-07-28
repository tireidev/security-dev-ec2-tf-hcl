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
  for_each       = local.db-subnets-id
  route_table_id = module.aws_route_table["prj-prd-db-route_table"].id
  subnet_id      = each.value
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
  source      = "./modules/security/aws_security_group"
  for_each    = var.aws_security_groups
  vpc_id      = module.aws_vpc[each.value.vpc_name].vpc_id
  Name        = each.value.Name
  description = each.value.description
  env         = each.value.env
  rules       = each.value.rules
}

# ========================================================== #
#   2.3. VPCエンドポイント構築
# ========================================================== #
module "aws_vpc_endpoint_interface" {
  source              = "./modules/network/aws_vpc_endpoint_interface"
  for_each            = var.aws_vpc_endpoint
  vpc_endpoint_type   = each.value.vpc_endpoint_type
  vpc_id              = module.aws_vpc[each.value.vpc_name].vpc_id
  service_name        = each.value.service_name
  subnet_ids          = module.aws_subnet[each.value.subnet_ids].id
  private_dns_enabled = each.value.private_dns_enabled
  security_group_ids  = module.aws_security_group[each.value.security_group_ids].id
}

# ========================================================== #
#   2.4. キーペア構築 ※EC2インスタンスにローカルマシンにてSSH接続でするため
# ========================================================== #
module "aws_key_pairs" {
  source             = "./modules/security/aws_key_pairs"
  for_each = var.aws_key_pairs
  key_name         = each.value.key_name
  private_key_name = each.value.private_key_name
  public_key_name  = each.value.public_key_name
  file_permission = each.value.file_permission
}

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