
resource "aws_instance" "ec2_instance_docker" {
    ami = "${lookup(var.ec2_config, "ami_id")}"
    instance_type = "${lookup(var.ec2_config, "instance_type")}"
    associate_public_ip_address = "${lookup(var.ec2_config, "associate_public_ip_address")}"
    key_name = "${var.aws_ssh_key_name}"
    vpc_security_group_ids = ["${var.sg_pdata}", "${var.sg_region}"]
    subnet_id = "${var.subnet_id}"

    tags = {
      Name = "${var.tag_name}"
    }

    timeouts {
      create = "3m"
      delete = "30m"
    }

}

resource "null_resource" "example_provisioner" {
    triggers = {
      public_ip = "${aws_instance.ec2_instance_docker.public_ip}"
    }

    connection {
      type     = "ssh"
      user     = "ec2-user"
      port = 22
      private_key = file("${var.aws_ssh_private_key_file}")
      host     = "${aws_instance.ec2_instance_docker.public_ip}"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "sudo yum install -y docker",
        "sudo service docker start",
        "sudo usermod -a -G docker ec2-user",
        "sudo curl -L \"https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
        "sudo chmod +x /usr/local/bin/docker-compose",
        "sudo ln -s -f /usr/local/bin/docker-compose /usr/bin/docker-compose",
        "sudo yum install -y amazon-efs-utils",
      ]
    }

    provisioner "remote-exec" {
      inline = [
        "mkdir -p ~/pdata",
      ]
    }

    provisioner "file" {
      source      = "../docker"
      destination = "/home/ec2-user/pdata/docker"
    }


    # The boot_init.sh is for calling the docker-compose after the EC2 host reboot
    provisioner "file" {
      source      = "file/boot_init.sh"
      destination = "/home/ec2-user/boot_init.sh"
    }
    provisioner "file" {
      source      = "file/retrieve_ips.sh"
      destination = "/home/ec2-user/retrieve_ips.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "echo ${aws_instance.ec2_instance_docker.private_ip} > /home/ec2-user/pdata/docker/app/host_ips.txt",
        "echo ${var.tag_name} > /home/ec2-user/pdata/docker/app/tag.txt",
        "echo ${var.tag_name2} > /home/ec2-user/pdata/docker/app/tag2.txt",
        "echo ${var.number_nginx} > /home/ec2-user/pdata/docker/app/number_nginx.txt",
        "echo ${var.elb_dns_name} > /home/ec2-user/pdata/docker/app/elb_dns_name.txt",
        #use crontab to restart docker-compose after the reboot 
        "sudo chkconfig crond on",
        "chmod 755  /home/ec2-user/boot_init.sh",
        #"sudo crontab -l; echo '@reboot sudo -u ec2-user /home/ec2-user/boot_init.sh >> /home/ec2-user/script_output.log 2>&1' | sudo crontab -",
        "chmod 755  /home/ec2-user/retrieve_ips.sh",
        "sudo crontab -l; echo '@reboot sudo -u ec2-user /home/ec2-user/retrieve_ips.sh >> /home/ec2-user/script_output.log 2>&1' | sudo crontab -",
        "echo ${var.efs_name} > /home/ec2-user/efs_name.txt",
        "nohup /home/ec2-user/retrieve_ips.sh &",
        "/home/ec2-user/boot_init.sh",
      ]
    }
}

