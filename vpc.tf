resource "aws_vpc" "vpc-default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "${var.project}"
  }
}
