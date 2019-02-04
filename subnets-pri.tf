/* subnet-pri */

module subnet-pri {
  source                  = "./modules/subnet/"
  vpc_id                  = "${aws_vpc.vpc-default.id}"
  cidr_block              = "${var.subnet-pri-cidr-block}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.availability_zone}"
  tag_name                = "${var.subnet-pri-tag-name}"
}

resource "aws_network_acl" "nacl" {
  vpc_id     = "${aws_vpc.vpc-default.id}"
  subnet_ids = ["${module.subnet-pri.subnet_id}"]

  tags {
    Name = "${ format("nacl-subnet-pri") }"
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

module nat-gateway {
  source            = "./modules/nat_gateway/"
  subnet_ids        = ["${module.subnet-pub.subnet_id}"]
  availability_zone = "${var.availability_zone}"
}

module "subnet-pri-ngw-route" {
  source                 = "./modules/ngw-route/"
  route_table_id         = ["${module.subnet-pri.route_tables_id}"]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${module.nat-gateway.ids}"
  tag_name               = "${var.subnet-pri-tag-name}"
  availability_zone      = "${var.availability_zone}"
}

#######################################################

