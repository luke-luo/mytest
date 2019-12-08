output "vpc_id" {
  value = "${module.us-east-1.vpc_id}"
}

output "aws_elb_dns_name" {
  value = "${module.us-east-1.aws_elb_dns_name}"
}

output "test_url" {
  value = "${module.us-east-1.aws_elb_dns_name}:8080"
}