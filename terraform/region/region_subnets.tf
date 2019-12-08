data "aws_availability_zones" "all" {
}

module "b_subnet_public" {
  source            = "../subnet_b"
  vpc_id            = "${aws_vpc.main.id}"
  vpc_gateway_id    = "${aws_internet_gateway.main.id}"
  vpc_name          = "${var.vpc["name"]}"
  subnet_names_list = "${var.subnet_names_list_public}"
  count_num         = 2
  route_table_id = "${aws_vpc.main.default_route_table_id}"
}

