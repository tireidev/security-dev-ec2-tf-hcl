u_aws_region = "ap-northeast-1"
# u_aws_vpc_cidr             = "10.0.0.0/16"
u_web_private_subnet_1a_ip = "10.0.1.0/24"
u_db_private_subnet_1a_ip  = "10.0.2.0/24"
u_db_private_subnet_1c_ip  = "10.0.3.0/24"
u_allowed_cidr_myip        = null
u_key_name                 = "hanson_key.pem"
u_private_key_name         = "hanson_key.pem"
u_public_key_name          = "hanson_key.pem.pub"
u_instance_profile_name    = ""
u_internet_gateway_id      = ""

vpc_setting = {
  prj-prd-vpc = {
    cidr                 = "10.0.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    env                  = "prd"
    Name                 = "prj-prd-vpc"
  }
  prj-stg-vpc = {
    cidr                 = "10.1.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    env                  = "stg"
    Name                 = "prj-stg-vpc"
  }
}

route_tables = {
  prj-prd-web-route_table = {
    vpc_name = "prj-prd-vpc"
    env      = "prd"
    Name     = "prj-prd-web-route_table"
  }
  prj-prd-db-route_table = {
    vpc_name = "prj-prd-vpc"
    env      = "prd"
    Name     = "prj-prd-db-route_table"
  }
}

subnets = {
  prj-prd-web-subnet-1a = {
    cidr_block = "10.0.1.0/24"
    env        = "prd"
    Name       = "prj-prd-web-subnet-1a"
  }
  prj-prd-db-subnet-1a = {
    cidr_block = "10.0.2.0/24"
    env        = "prd"
    Name       = " prj-prd-db-subnet-1a"
  }
  prj-prd-db-subnet-1c = {
    cidr_block = "10.0.3.0/24"
    env        = "prd"
    Name       = "prj-prd-db-subnet-1c"
  }
}

aws_security_groups = {

  vpc_endpoint_sg = {
    Name       = "prj-dev-vpc-endpoint-sg"
    description = "Allow https traffic."
    env        = "prd"
    rules = {
      type = "ingress",
      from_port = "443",
      to_port = "443",
      protocol = "tcp",
      cidr_blocks = "10.0.0.0/16"
    }
  }

  vpc_ec2_sg = {
    Name       = "prj_dev_ec2_sg"
    description = "Allow all outbound traffic."
    env        = "prd"
    rules = {
      type = "egress",
      from_port = "0",
      to_port = "0",
      protocol = "-1",
      cidr_blocks = "0.0.0.0/0"
    }
  }
  
  vpc_db_sg = {
    Name       = "prj_dev_db_sg"
    description = "Allow traffic."
    env        = "prd"
    rules = {
      type = "ingress",
      from_port = "5432",
      to_port = "5432",
      protocol = "tcp",
      cidr_blocks = "10.0.0.0/16"
    }
  }
}