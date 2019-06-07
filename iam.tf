resource "aws_iam_role" "lambda-run-command-ec2-role" {
  name = "dq-lambda-run-command-ec2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com",
        "Serivce": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda-run-command-ec2-policy" {
  name = "lambda-run-command-ec2"
  role = "${aws_iam_role.lambda-run-command-ec2-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:GetParameter"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ssm:eu-west-2:*:parameter/ssh_key_private"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "lambda-run-command-ec2-profile" {
  role = "${aws_iam_role.lambda-run-command-ec2-role.name}"
}
