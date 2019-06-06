data "aws_ssm_parameter" "ssh_key_private" {
  name = "ssh_key_private"
}

data "aws_ssm_parameter" "slack_notification_webhook" {
  name = "slack_notification_webhook"
}
