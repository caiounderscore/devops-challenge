variable "ami" {}

variable "instance_type" {}

variable "instance_name" {}

variable "network_id" {}

variable "key_name" {}

variable "user_data_file" {}

variable "security_groups" {
  type = "list"
}

variable "project" {}

resource "aws_instance" "instance" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.network_id}"
  vpc_security_group_ids = ["${var.security_groups}"]
  key_name               = "${var.key_name}"
  user_data              = "${file("${var.user_data_file}")}"

  tags = {
    Name    = "${var.instance_name}"
    Project = "${var.project}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "instance-id" {
  value = "${ aws_instance.instance.id }"
}
