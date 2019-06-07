locals {
  path_module = "${var.path_module != "unset" ? var.path_module : path.module}"
}

variable "namespace" {
  description = "Namespace variable"
}

variable "instance_id" {
  description = "The ID of the EC2 instnace"
}

variable "ip_address" {
  description = "The IP address of the EC2 instance"
}

variable "ssh_user" {
  description = "SSH User for EC2 instance"
}

variable "command" {
  description = "The command to be run"
}

variable "naming_suffix" {
  description = "Local naming suffix"
}

variable "path_module" {
  default = "unset"
}

variable "lambda_subnet" {
  description = "Lambda subnet ID"
}

variable "lambda_subnet_az2" {
  description = "Lambda subnet ID"
}

variable "security_group_ids" {
  description = "Lambda security group ID"
}

variable "count_tag" {
  description = "Sets the value of count based on module input"
  default     = "0"
}
