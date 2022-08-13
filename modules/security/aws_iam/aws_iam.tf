# ========================================================== #
# [処理名]
# IAMポリシー作成
# 
# [概要]
# IAMポリシー作成
# ========================================================== #

# ========================================================== #
# VPCエンドポイントで使用するIAMポリシーを作成する
# ========================================================== #
data "aws_iam_policy_document" "ssm_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm_role" {
  name               = "EC2RoleforSSM"
  assume_role_policy = data.aws_iam_policy_document.ssm_role.json
}

resource "aws_iam_instance_profile" "ssm_role" {
  name = "EC2RoleforSSM"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_role" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

output "instance_profile_name" {
  value = "${aws_iam_instance_profile.ssm_role.name}"
}