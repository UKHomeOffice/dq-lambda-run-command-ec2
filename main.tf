data "archive_file" "lambda_run_ec2_command_zip" {
  type        = "zip"
  source_dir  = "${local.path_module}/lambda/command/code"
  output_path = "${local.path_module}/lambda/command/code/package/lambda.zip"
}

resource "aws_lambda_function" "lambda_run_ec2_command" {
  count            = "${var.count_tag}"
  filename         = "lambda/command/package/lambda.zip"
  function_name    = "run-ec2-command-${var.naming_suffix}"
  role             = "${aws_iam_role.lambda-run-command-ec2-role.arn}"
  handler          = "api.lambda_handler"
  source_code_hash = "${data.archive_file.lambda_run_ec2_command_zip.output_base64sha256}"
  runtime          = "python3.7"
  timeout          = "900"
  memory_size      = "196"

  vpc_config = {
    subnet_ids         = ["${var.lambda_subnet}", "${var.lambda_subnet_az2}"]
    security_group_ids = ["${var.security_group_ids}"]
  }

  environment {
    variables = {
      INSTANCE_ID   = "${var.instance_id}"
      IP_ADDRESS    = "${var.ip_address}"
      SSH_USER      = "${var.ssh_user}"
      SSH_KEY       = "${data.aws_ssm_parameter.ssh_key_private.value}"
      COMMAND       = "${var.command}"
      SLACK_WEBHOOK = "${data.aws_ssm_parameter.slack_notification_webhook.value}"
    }
  }

  tags = {
    Name = "lambda-ec2-command-run-${var.naming_suffix}"
  }
}

resource "aws_cloudwatch_log_group" "lambda_run_ec2_command_log_group" {
  count             = "${var.count_tag}"
  name              = "/aws/lambda/${aws_lambda_function.lambda_run_ec2_command.function_name}"
  retention_in_days = 14

  tags = {
    Name = "lambda-run-ec2-command-log-group-${var.naming_suffix}"
  }
}
