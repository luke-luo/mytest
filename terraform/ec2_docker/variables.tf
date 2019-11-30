variable "vpc_id" {}
variable "vpc_name" {}

data "aws_vpc" "target" {
  id = "${var.vpc_id}"
  tags = {
    Name = "${var.vpc_name}"
  }
}

variable "ec2_config" {
  type = "map"
}

variable "ec2_security_groups" {
  type = "list"
}

variable "sg_region" {}

variable "sg_pdata" {}

variable "tag_name" {}

variable "subnet_id" {}

variable "aws_ssh_private_key_file" {}
variable "aws_ssh_key_name" {}

variable "number_nginx" {}

