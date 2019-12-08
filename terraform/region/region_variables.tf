variable "base_cidr_block" {}

variable "aws_ssh_private_key_file" {}
variable "aws_ssh_key_name" {}


variable "vpc" {
  type = "map"
}

variable "common_office_ip" {}

variable "subnet_names_list_public" {
  type = "list"
}


variable "security_group_name_list" {
  type = "list"
}


variable "ec2_config_pdata" {
  type = "map"
}

variable "ec2_security_groups_pdata" {
  type = "list"
}

variable "number_nginx" {}





