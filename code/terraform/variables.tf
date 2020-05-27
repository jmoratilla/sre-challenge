variable "aws_key_name" {
  description = "The SSH key name used to access the instance"
}

variable "aws_ssh_user" {
  description = "The ssh user to connect"
  default = "admin"
}

variable "private_key_path" {
  description = "The SSH private key file"
}
