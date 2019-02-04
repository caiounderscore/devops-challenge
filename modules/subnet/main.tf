variable "cidr_block" {
  description = "List of subnets"
  type        = "list"
}

variable "availability_zone" {
  description = "AZ"
  type        = "list"
}

variable "map_public_ip_on_launch" {
  description = "MAP IP Public config"
  type        = "string"
  default     = "false"
}

variable "tag_name" {
  description = "Subnet Tag Name"
  type        = "list"
}

variable "vpc_id" {}

resource "aws_subnet" "subnet" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${element(var.cidr_block, count.index)}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  tags {
    Name = "${ format("%s", element(var.tag_name, count.index) ) }"
  }

  count = "${length(var.availability_zone)}"
}

resource "aws_route_table" "rtable" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${ format("rt-%s", element(var.tag_name, count.index) ) }"
  }

  count = "${length(var.availability_zone)}"
}

resource "aws_route_table_association" "rtable_association" {
  subnet_id      = "${ aws_subnet.subnet.*.id[count.index] }"
  route_table_id = "${ aws_route_table.rtable.*.id[count.index] }"
  count          = "${ length  (var.availability_zone) }"
}

output "subnet_id" {
  value = ["${ aws_subnet.subnet.*.id }"]
}

output "route_tables_id" {
  value = ["${ aws_route_table.rtable.*.id }"]
}
