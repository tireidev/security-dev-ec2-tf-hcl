
data  "aws_iam_policy_document" "vpc_endpoint" {
  statement {
    effect    = "Allow"
    actions   = [ "*" ]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_endpoint_type = var.vpc_endpoint_type
  vpc_id            =  var.vpc_id
  service_name      = var.service_name
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    var.subnet_ids
  ]
  private_dns_enabled = var.private_dns_enabled
  security_group_ids = [
    var.security_group_ids
  ]
}

# resource "aws_vpc_endpoint" "ssmmessages" {
#   vpc_endpoint_type = "Interface"
#   vpc_id            = var.u_vpc_id
#   service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
#   policy            = data.aws_iam_policy_document.vpc_endpoint.json
#   subnet_ids = [
#     var.u_web_private_subnet_1a_id
#   ]
#   private_dns_enabled = true
#   security_group_ids = [
#     var.u_vpc_endpoint_sg_id
#   ]
# }

# resource "aws_vpc_endpoint" "ec2messages" {
#   vpc_endpoint_type = "Interface"
#   vpc_id            = var.u_vpc_id
#   service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
#   policy            = data.aws_iam_policy_document.vpc_endpoint.json
#   subnet_ids = [
#     var.u_web_private_subnet_1a_id
#   ]
#   private_dns_enabled = true
#   security_group_ids = [
#     var.u_vpc_endpoint_sg_id
#   ]
# }