provider "aws" {
  region = "us-east-1"
  alias = "east1"
}

provider "aws" {
  region = "us-east-2"
  alias = "east2"
}


module "us-east-1" {
  source          = "./region"
  #region          = "us-east-1"
  
  providers = {
    aws = aws.east1
  }
  
  base_cidr_block = "${var.base_cidr_block}"
  vpc = "${var.vpc}"
  common_office_ip = "${var.common_office_ip}"
  
  subnet_names_list_public = "${var.subnet_names_list_public}"
  
  security_group_name_list = "${var.security_group_name_list}"
  
  ec2_config_pdata = "${var.ec2_config_pdata}"
  ec2_security_groups_pdata = "${var.ec2_security_groups_pdata}"

  aws_ssh_private_key_file = "${var.aws_ssh_private_key_file}"
  aws_ssh_key_name = "${var.aws_ssh_key_name}"

  number_nginx = "${var.number_nginx}"
}


