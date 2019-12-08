
module "ec2_docker1" {
  source            = "../ec2_docker"

  vpc_id            = "${aws_vpc.main.id}"
  vpc_name          = "${var.vpc["name"]}"
  ec2_config = "${var.ec2_config_pdata}"
  ec2_security_groups = "${var.ec2_security_groups_pdata}"
  sg_region = "${aws_security_group.region.id}"
  sg_pdata = "${aws_security_group.sg_pdata.id}"
  subnet_id = "${module.b_subnet_public.subnet_id.0}"
  tag_name = "${var.vpc["name"]}-docker1"
  tag_name2 = "${var.vpc["name"]}-docker2"
  aws_ssh_private_key_file = "${var.aws_ssh_private_key_file}"
  aws_ssh_key_name = "${var.aws_ssh_key_name}"
  number_nginx = "${var.number_nginx}"
  efs_name = "${aws_efs_mount_target.pdata_efs_mount_target0.dns_name}"
  elb_dns_name = "${aws_lb.elb.dns_name}"
}

module "ec2_docker2" {
  source            = "../ec2_docker"

  vpc_id            = "${aws_vpc.main.id}"
  vpc_name          = "${var.vpc["name"]}"
  ec2_config = "${var.ec2_config_pdata}"
  ec2_security_groups = "${var.ec2_security_groups_pdata}"
  sg_region = "${aws_security_group.region.id}"
  sg_pdata = "${aws_security_group.sg_pdata.id}"
  subnet_id = "${module.b_subnet_public.subnet_id.1}"
  tag_name = "${var.vpc["name"]}-docker2"
  tag_name2 = "${var.vpc["name"]}-docker1"
  aws_ssh_private_key_file = "${var.aws_ssh_private_key_file}"
  aws_ssh_key_name = "${var.aws_ssh_key_name}"
  number_nginx = "${var.number_nginx}"
  efs_name = "${aws_efs_mount_target.pdata_efs_mount_target1.dns_name}"
  elb_dns_name = "${aws_lb.elb.dns_name}"
}

