variable security_group_name {}

variable "ingress_cdir" {}

variable "vpc_id" {}

variable "from_port" {}

variable "to_port" {}

resource "aws_security_group" "sg" {
  name_prefix = "${var.security_group_name}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.from_port}"
    to_port     = "${var.to_port}"
    protocol    = "-1"
    cidr_blocks = ["${var.ingress_cdir}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "id" {
  value = "${aws_security_group.sg.id}"
}
