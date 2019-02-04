####### subnets publicas

module subnet-pub {
  source                  = "./modules/subnet/"
  vpc_id                  = "${aws_vpc.vpc-default.id}"
  cidr_block              = "${var.subnet-pub-cidr-block}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.availability_zone}"
  tag_name                = "${var.subnet-pub-tag-name}"
}

resource "aws_network_acl" "subnet-pub" {
  vpc_id     = "${aws_vpc.vpc-default.id}"
  subnet_ids = ["${module.subnet-pub.subnet_id}"]

  tags {
    Name = "${ format("nacl-subnet-pub") }"
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
    action     = "allow"
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
    action     = "allow"
  }
}

module "subnet-pub-igw-route" {
  source                 = "./modules/igw-route/"
  route_table_id         = ["${module.subnet-pub.route_tables_id}"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw-default.id}"
  tag_name               = "${var.subnet-pub-tag-name}"
  availability_zone      = "${var.availability_zone}"
}
