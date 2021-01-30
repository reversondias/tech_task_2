resource "aws_iam_role" "s3_role" {
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
  name = aws_iam_role.s3_role.name
  role = aws_iam_role.s3_role.name
}

resource "aws_iam_policy" "s3_role_policy" {
  name = "s3-access-role-policy"
  description = "This policy allow EC2 full access one bucket S3"

  policy = templatefile("s3_policy_json_template.tpl", {s3_name = var.s3_name})
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3_role_policy.arn
}