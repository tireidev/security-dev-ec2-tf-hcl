
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