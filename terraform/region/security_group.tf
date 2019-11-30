
resource "aws_security_group" "region" {
  name        = "region"
  description = "Open access within this region"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self = "true"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.vpc.name}-sg-region"
  }
}

resource "aws_security_group" "sg_pdata" {
  name        = "${var.vpc["name"]}-sg-ansible"
  description = "Open access within this region for ansible server"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = "${var.common_office_ip}"
  }
  
  tags = {
    Name = "${var.vpc["name"]}-sg-pdata"
  }
}


