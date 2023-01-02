u_aws_region               = "ap-northeast-1"
u_aws_vpc_cidr             = "10.0.0.0/16"
u_web_private_subnet_1a_ip = "10.0.1.0/24"
u_db_private_subnet_1a_ip  = "10.0.2.0/24"
u_db_private_subnet_1c_ip  = "10.0.3.0/24"
u_allowed_cidr_myip        = null
u_key_name                 = "hanson_key.pem"
u_private_key_name         = "hanson_key.pem"
u_public_key_name          = "hanson_key.pem.pub"
u_instance_profile_name    = ""
u_internet_gateway_id      = ""
# vpc_setting = {
#   prj-prd-vpc = {
#     "cidr"                 = "10.0.0.0/16"
#     "instance_tenancy"     = "default"
#     "enable_dns_support"   = true
#     "enable_dns_hostnames" = true
#     "env" = "prd"
#     "name" = "prj-prd-vpc"
#   }
#   prj-stg-vpc = {
#     "cidr"                 = "10.1.0.0/16"
#     "instance_tenancy"     = "default"
#     "enable_dns_support"   = true
#     "enable_dns_hostnames" = true
#     "env" = "stg"
#     "name" = "prj-stg-vpc"
#   }
# }