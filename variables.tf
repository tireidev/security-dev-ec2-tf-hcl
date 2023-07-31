variable "u_aws_region" {}
# variable "u_aws_vpc_cidr" {}
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
  type = map(object({
    cidr                 = string
    instance_tenancy     = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    env                  = string
    Name                 = string
  }))
  description = ""
  default = {
    default_object = {
      cidr                 = null
      instance_tenancy     = null
      enable_dns_support   = true
      enable_dns_hostnames = true
      env                  = null
      Name                 = null
    }
  }
}
variable "route_tables" {
  type = map(object({
    vpc_name = string
    env      = string
    Name     = string
  }))
  description = ""
  default = {
    vpc_name = null
    env      = null
    Name     = null
  }
}

variable "subnets" {
  type = map(object({
    cidr_block = string
    env        = string
    Name       = string
  }))
  description = ""
  default = {
    cidr_block = null
    env        = null
    Name       = null
  }
}
variable "aws_security_groups" {
  type = map(object({
    vpc_name    = string
    Name        = string
    description = string
    env         = string
    rules = object({
      type        = string,
      from_port   = string,
      to_port     = string,
      protocol    = string,
      cidr_blocks = string
    })
  }))
  description = ""
  default = {
    vpc_name    = null
    Name        = null
    description = null
    env         = null
    rules       = null
  }
}

variable "aws_vpc_endpoint" {
  type = map(object({
    vpc_endpoint_type   = string
    vpc_name            = string
    service_name        = string
    subnet_ids          = string
    private_dns_enabled = bool
    security_group_ids  = string
  }))
  description = ""
  default = {
    default_object = {
      vpc_endpoint_type   = "Interface"
      vpc_name            = null
      service_name        = null
      subnet_ids          = null
      private_dns_enabled = false
      security_group_ids  = null
    }
  }
}

variable "aws_key_pairs" {
  type = map(object({
    key_name         = string
    private_key_name = string
    public_key_name  = string
    file_permission  = string
  }))
  description = ""
  default = {
    default_object = {
      key_name         = "hanson_key.pem"
      private_key_name = "hanson_key.pem"
      public_key_name  = "hanson_key.pem.pub"
      file_permission  = "0600"
    }
  }
}

variable "aws_instance" {
  type = map(object({
    ami                         = string
    instance_type               = string
    subnet_name                 = string
    vpc_security_group_names    = set(string)
    key_name                    = string
    iam_instance_profile        = string
    volume_size                 = number
    volume_type                 = string
    iops                        = number
    throughput                  = number
    delete_on_termination       = bool
    root_block_device_tags_Name = string
    tags_Env                    = string
    tags_Name                   = string
  }))
}

variable "aws_db_subnet_group" {
  type = map(object({
    name         = string
    subnet_names = set(string)
  }))
}

variable "aws_db_instance" {
  type = map(object({
    identifier             = string
    allocated_storage      = number
    storage_type           = string
    engine                 = string
    engine_version         = string
    instance_class         = string
    db_name                = string
    username               = string
    password               = string
    vpc_security_group_names = set(string)
    db_subnet_group_name   = string
    skip_final_snapshot    = bool
  }))
}