variable "u_aws_region" {}
variable "u_aws_vpc_cidr" {}
variable "u_web_private_subnet_1a_ip" {}
variable "u_db_private_subnet_1a_ip" {}
variable "u_db_private_subnet_1c_ip" {}
variable "u_allowed_cidr_myip" {}
variable "u_key_name" {}
variable "u_private_key_name" {}
variable "u_public_key_name" {}
variable "u_instance_profile_name" {}
variable "u_internet_gateway_id" {}
variable "vpc_setting" {
  type        = map(map(string))
  description = ""
  default = {
    "default" = {
      "cidr" = null
      "instance_tenancy" = null
      "enable_dns_support" = true
      "enable_dns_hostnames" = true
      "env" = null
      "name" = null
    }
  }
}