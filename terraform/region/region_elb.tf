/*

resource "aws_lb_target_group" "targetgroup" {
  name     = "pdata-target"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main.id}"
  health_check {
      interval = 10
      path = "/"
      protocol = "HTTP"
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
      matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "elb_ec2_1" {
  target_group_arn = "${aws_lb_target_group.targetgroup.arn}"
  target_id        = "${module.ec2_docker1.ec2_id}"
  port             = 3000
}

resource "aws_lb_target_group_attachment" "elb_ec2_2" {
  target_group_arn = "${aws_lb_target_group.targetgroup.arn}"
  target_id        = "${module.ec2_docker2.ec2_id}"
  port             = 3000
}

resource "aws_lb" "elb" {
  name               = "pdata-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.sg_pdata.id}", "${aws_security_group.region.id}"]
  subnets            = ["${module.b_subnet_public.subnet_id.0}", "${module.b_subnet_public.subnet_id.1}"]

  enable_deletion_protection = false

  access_logs {
    bucket  = "my.log.elb"
    prefix  = "pdata"
    enabled = false
  }

  tags = {
    Environment = "pdata"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_lb.elb.arn}"
  port              = "3000"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.targetgroup.arn}"
  }
}

*/