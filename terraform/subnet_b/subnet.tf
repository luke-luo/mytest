#data "aws_availability_zones" "all" {
#}


resource "aws_subnet" "main1" {
  count      = "${var.count_num}"
  cidr_block = "${cidrsubnet(data.aws_vpc.target.cidr_block, 8, count.index)}"
  availability_zone = "${lookup(var.subnet_names_list[count.index], "availability_zone")}"

  vpc_id     = "${var.vpc_id}"
  tags = {
    Name = "${data.aws_vpc.target.tags.Name}-subnet-${count.index}"
  }
}

