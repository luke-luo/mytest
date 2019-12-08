
output "default_route_table_id" {
  value = "${var.route_table_id}"
}

output "subnet_id" {
  value = "${aws_subnet.main1.*.id}"
}