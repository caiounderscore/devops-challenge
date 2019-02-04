module sg-http-traffic-external {
  source              = "./modules/security-group/"
  security_group_name = "http-traffic-external"
  ingress_cdir        = "0.0.0.0/0"
  vpc_id              = "${aws_vpc.vpc-default.id}"
  from_port           = 0
  to_port             = 0
}

resource "aws_lb_target_group" "tg" {
  name_prefix = "tg-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.vpc-default.id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
  }

  tags {
    Project = "${var.project}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "alb" {
  name_prefix        = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${module.sg-http-traffic-external.id}"]
  subnets            = ["${module.subnet-pub.subnet_id}"]

  tags {
    Project = "${var.project}"
  }

  enable_deletion_protection = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "listener-80" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tg.arn}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "attach-ec2-nginx" {
  target_group_arn = "${aws_lb_target_group.tg.arn}"
  target_id        = "${module.ec2-nginx.instance-id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach-ec2-apache" {
  target_group_arn = "${aws_lb_target_group.tg.arn}"
  target_id        = "${module.ec2-apache.instance-id}"
  port             = 80
}
