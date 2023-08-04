
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

resource "aws_vpc_endpoint" "this" {
  vpc_endpoint_type = var.vpc_endpoint_type
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  route_table_ids   = var.route_table_ids
}

# resource "aws_vpc_endpoint" "s3" {
#   vpc_endpoint_type = "Gateway"
#   vpc_id            = var.u_vpc_id
#   service_name      = "com.amazonaws.ap-northeast-1.s3"
#   policy            = data.aws_iam_policy_document.vpc_endpoint.json
#   route_table_ids = [
#     var.u_vpc_endpoint_route_table_id
#   ]
# }