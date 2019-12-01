
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

# Allow both ingress and egress for port 2049 (NFS)
# such that our instances are able to get to the mount
# target in the AZ.
#
# Additionaly, we set the `cidr_blocks` that are allowed
# such that we restrict the traffic to machines that are
# within the VPC (and not outside).
resource "aws_security_group" "pdata_efs" {
  name        = "pdata_efs_mnt"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      #"${data.aws_vpc.main.cidr_block}",
      "${aws_vpc.main.cidr_block}",
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      #"${data.aws_vpc.main.cidr_block}",
      "${aws_vpc.main.cidr_block}",
    ]
  }

  tags = {
    Name = "pdata_allow_nfs_ec2"
  }
}

