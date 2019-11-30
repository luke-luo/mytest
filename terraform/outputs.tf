
output "vpc_id" {
  value = ["${module.us-east-1.vpc_id}"]
}

output "subnet_name" {
  value = ["${var.subnet_names_list_public}"]
}

output "route_table_id" {
  value = ["${module.us-east-1.routetable_id}"]
}

