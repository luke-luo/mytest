variable "base_cidr_block" {
  default = "10.10.0.0/16"             #user defined CIDR block, must use "x.0.0.0/16" format
}

variable "vpc" {
  default = {
    name = "pdata"         #user defined VPC name
  }
}

variable "common_office_ip" {
  default = [
  "98.113.116.83/32" #office_ip
  ]
}

#define subnet here to have internet access
variable "subnet_names_list_public" {
  type    = "list"
  default = [
    {
      name = "1a"                  #user defined, the postfix name for subnet
      availability_zone = "us-east-1a"
    },  
    {
      name = "1b"                  #user defined, the postfix name for subnet
      availability_zone = "us-east-1b"
    }
  ]  
}

variable "security_group_name_list" {
  type = "list"
  default = [
    {
        name = "22"            #user defined, the postfix name for sg
        from_port = "22"
        to_port = "22"
        protocol = "tcp"
    },
    {
        name = "8080"          #user defined, the postfix name for sg
        from_port = "8080"
        to_port = "8080"
        protocol = "tcp"
    }
  ]
}

variable "ec2_config_pdata" {
  type = "map"
  default = {
    total = "1"                                  #user defined, the instnace count in this group
    name = "pdata-ec2"                  #user defined, for the postfix name in EC2 tags 'Name'
    ami_id = "ami-00eb20669e0990cb4"
    associate_public_ip_address = "true"
    instance_type = "t2.micro"
    subnet = "public1"                           #The name here must be matched to one of the user defined subnet name in either "subnet_names_list_public" or "subnet_names_list_private"
  }
}

variable "ec2_security_groups_pdata" {
  type = "list"
  default = ["22"]                               #The name here must be matched to one of the user defined security group name in "security_group_name_list"
}


variable "aws_ssh_key_name" {
  default = "pdata_test"        #This SSH key name must exist in AWS before create this EC2 instance
}

variable "aws_ssh_private_key_file" {
  default = "./pdata_test.pem"        #This SSH key file must exist in your file system
}

variable "number_nginx" {
  default = "6"
}

