
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
      ]
    }

    provisioner "remote-exec" {
      inline = [
        "mkdir -p ~/pdata",
      ]
    }

    provisioner "local-exec" {
      command = "echo ${aws_instance.ec2_instance_docker.private_ip} > ../docker/app/host_ips.txt"
      #command = "echo ${aws_instance.ec2_instance_docker.private_ip} > host_ips.txt"
    }

    provisioner "local-exec" {
      command = "echo ${aws_instance.ec2_instance_docker.private_ip} > ${aws_instance.ec2_instance_docker.id}.txt"
    }

    provisioner "file" {
      source      = "../docker"
      destination = "~/pdata"
    }

    provisioner "remote-exec" {
      inline = [
        "cd ~/pdata/docker && docker-compose up -d",
        "cd ~/pdata/docker && docker-compose scale app=${tonumber(var.number_nginx)}",
        #"cd ~/pdata/docker && nohup docker-compose up > /dev/null 2>&1 &",
      ]
    }

/*
    provisioner "remote-exec" {
      inline = [
        #"cd ~/pdata/docker && docker-compose scale app=${var.number_nginx}",
        "cd ~/pdata/docker && docker-compose scale app=9",
      ]
    }
*/

/*
    provisioner "remote-exec" {
      inline = [
        "mkdir -p ~/tmp",
        "mkdir -p ~/tmp/test",
      ]
    }

    provisioner "file" {
      source      = "../quest-master.zip"
      destination = "~/tmp/quest-master.zip"
    }


    provisioner "remote-exec" {
      inline = [
        "unzip -o ~/tmp/quest-master.zip -d ~/tmp/test/",
      ]
    }

    provisioner "file" {
      source      = "ec2_docker/Dockerfile"
      destination = "~/tmp/test/quest-master/Dockerfile"
    }

    provisioner "file" {
      source      = "ec2_docker/start_nodejs.sh"
      destination = "~/tmp/test/quest-master/start_nodejs.sh"
    }

    provisioner "remote-exec" {
      inline = [
        "cd ~/tmp/test/quest-master && docker build -t pdata .",
        "cd ~/tmp/test/quest-master && docker run -p 3000:3000 -d pdata",
      ]
    }
*/
}
