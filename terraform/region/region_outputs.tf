output "vpc_id" {
  value = "${aws_vpc.main.id}"
}


output "routetable_id" {
  value = "${aws_vpc.main.default_route_table_id}"
}

output "aws_elb_dns_name" {
  value = "${aws_lb.elb.dns_name}"
}
