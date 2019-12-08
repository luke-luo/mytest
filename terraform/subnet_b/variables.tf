variable "vpc_id" {}
variable "vpc_name" {}

data "aws_vpc" "target" {
  id = "${var.vpc_id}"
  tags = {
    Name = "${var.vpc_name}"
  }
}

variable "subnet_names_list" {
  type = "list"
}

variable "route_table_id" {}
variable "vpc_gateway_id" {}

variable "count_num" {}

