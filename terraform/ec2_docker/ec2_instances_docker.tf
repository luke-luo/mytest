
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


/*
    # Generate a file to contain the host IP
    provisioner "local-exec" {
      command = "echo ${aws_instance.ec2_instance_docker.private_ip} > ../docker/app/host_ips.txt"
      #command = "echo ${aws_instance.ec2_instance_docker.private_ip} > host_ips.txt"
    }
*/

    provisioner "file" {
      source      = "../docker"
      destination = "/home/ec2-user/pdata/docker"
    }


    # The boot_init.sh is for calling the docker-compose after the EC2 host reboot
    provisioner "file" {
      source      = "boot_init.sh"
      destination = "/home/ec2-user/boot_init.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "echo ${aws_instance.ec2_instance_docker.private_ip} > /home/ec2-user/pdata/docker/app/host_ips.txt",
        #use crontab to restart docker-compose after the reboot 
        "sudo chkconfig crond on",
        "chmod 755  /home/ec2-user/boot_init.sh",
        "sudo crontab -l; echo '@reboot sudo -u ec2-user /home/ec2-user/boot_init.sh >> /home/ec2-user/script_output.log 2>&1' | sudo crontab -",
        "echo ${var.efs_name} > /home/ec2-user/efs_name.txt",
        "/home/ec2-user/boot_init.sh",
        /*
        #mount EFS
        "sudo mkdir -p efs",
        "sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \"${aws_efs_mount_target.0.dns_name}\":/ efs",
        "sudo chown -R ec2-user efs",
        #start the docker-compose
        "cd ~/pdata/docker && docker-compose up -d --scale app=${tonumber(var.number_nginx)}",
        #"cd ~/pdata/docker && docker-compose scale app=${tonumber(var.number_nginx)}",
        */
      ]
    }
}

