resource "tls_private_key" "default-private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.project}"
  public_key = "${tls_private_key.default-private-key.public_key_openssh}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

module sg-all-traffic-internal {
  source              = "./modules/security-group/"
  security_group_name = "all-traffic-internal"
  ingress_cdir        = "${var.vpc_cidr}"
  vpc_id              = "${aws_vpc.vpc-default.id}"
  from_port           = 0
  to_port             = 0
}

module ec2-nginx {
  source          = "./modules/ec2/"
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  instance_name   = "${ format("%s-nginx", var.project)}"
  network_id      = "${element(module.subnet-pri.subnet_id, 1)}"
  user_data_file  = "./files/user_data_nginx.sh"
  security_groups = ["${module.sg-all-traffic-internal.id}"]
  project         = "${var.project}"
  key_name        = "${aws_key_pair.generated_key.key_name}"
}

module ec2-apache {
  source          = "./modules/ec2/"
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  instance_name   = "${ format("%s-apache", var.project)}"
  network_id      = "${element(module.subnet-pri.subnet_id, 2)}"
  user_data_file  = "./files/user_data_apache.sh"
  security_groups = ["${module.sg-all-traffic-internal.id}"]
  project         = "${var.project}"
  key_name        = "${aws_key_pair.generated_key.key_name}"
}
