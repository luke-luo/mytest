resource "aws_instance" "ec2_instance_jumper" {
    ami = "${lookup(var.ec2_config_pdata, "ami_id")}"
    instance_type = "${lookup(var.ec2_config_pdata, "instance_type")}"
    associate_public_ip_address="true"
    key_name = "${var.aws_ssh_key_name}"
    #vpc_security_group_ids = ["${var.sg_pdata}", "${var.sg_region}"]
    #sg_region = "${aws_security_group.region.id}"
    #sg_pdata = "${aws_security_group.sg_pdata.id}"

    vpc_security_group_ids = ["${aws_security_group.sg_pdata.id}", "${aws_security_group.region.id}"]
    subnet_id = "${module.b_subnet_public.subnet_id.0}"

    tags = {
      Name = "${var.vpc["name"]}-jumper"
    }
}

resource "null_resource" "jumper_provisioner" {
    triggers = {
      public_ip = "${aws_instance.ec2_instance_jumper.public_ip}"
    }

    connection {
      type     = "ssh"
      user     = "ec2-user"
      port = 22
      private_key = file("${var.aws_ssh_private_key_file}")
      host     = "${aws_instance.ec2_instance_jumper.public_ip}"
    }

    provisioner "remote-exec" {
      inline = [
        "mkdir -p ~/.ssh",
      ]
    }

    provisioner "file" {
      source      = "${var.aws_ssh_private_key_file}"
      destination = "~/.ssh/id_rsa"
    }

    provisioner "remote-exec" {
      inline = [
        "chmod 600 ~/.ssh/id_rsa",
      ]
    }

    provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "sudo yum install -y amazon-efs-utils",
        #mount EFS
        "sudo mkdir -p efs",
        "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \"${aws_efs_mount_target.pdata_efs_mount_target0.dns_name}\":/ efs",
        "sudo chown -R ec2-user efs",
      ]
    }

}