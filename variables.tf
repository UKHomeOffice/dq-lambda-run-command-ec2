locals {
  path_module   = "${var.path_module != "unset" ? var.path_module : path.module}"
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
