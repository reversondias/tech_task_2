resource "aws_iam_role" "s3-role" {
  name = "s3-access-role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "ec2-acess-profile" {
  name = aws_iam_role.s3-role.name
  role = aws_iam_role.s3-role.name
}

resource "aws_iam_role_policy" "s3-role-policy" {
  name = "s3-access-role-policy"
  role = aws_iam_role.s3-role.id

  policy = templatefile("s3_policy_json_template.tpl", {aws_account_id = var.aws_account_id, s3_name = var.s3_name})
}
