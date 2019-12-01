resource "aws_vpc" "main" {
  cidr_block = "${var.base_cidr_block}"
  enable_dns_hostnames ="true"

  tags = {
    Name = "${var.vpc["name"]}"
  }  
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  
  tags = {
    Name = "${var.vpc["name"]}-igw"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = {
    Name = "main table"
  }
}

