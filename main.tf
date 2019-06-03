data "archive_file" "lambda_api_zip" {
  type        = "zip"
  source_dir  = "${local.path_module}/lambda/command/code"
  output_path = "${local.path_module}/lambda/command/package/lambda.zip"
}


resource "aws_lambda_function" "lambda_api" {
  filename         = "${path.module}/lambda/command/package/lambda.zip"
  function_name    = "${var.pipeline_name}-${var.namespace}-lambda"
  role             = "${aws_iam_role.lambda_api.arn}"
  handler          = "api.lambda_handler"
  source_code_hash = "${data.archive_file.lambda_api_zip.output_base64sha256}"
  runtime          = "python3.7"
  timeout          = "900"
  memory_size      = "196"

  environment {
    variables = {
      instance_id = "${var.instance_id}"
      ssh_user    = "${var.ssh_user}"
      ssh_key     = "${var.ssh_key}"
      command     = "${var.command}"
    }
  }

  tags = {
    Name = ""
  }
}
