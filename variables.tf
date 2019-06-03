variable "namespace" {
  description = "Namespace variable"
}

variable "instance_id" {
  description = "The ID of the EC2 instnace"
}

variable "ssh_user" {
  description = "SSH User for EC2 instance"
}

variable "ssh_key" {
  description = "SSH Key for EC2 instance"
}

variable "command" {
  description = "The command to be run"
}
