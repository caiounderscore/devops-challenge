variable "route_table_id" {
  description = "Route Table ID"
  type        = "list"
}

variable "destination_cidr_block" {
  description = "Destination Target"
}

variable "nat_gateway_id" {
  description = "Identifiers of VPC NAT gateway"
  type        = "list"
}

variable "tag_name" {
  type = "list"
}

variable "availability_zone" {
  type = "list"
}

resource "aws_route" "route" {
  route_table_id         = "${element(var.route_table_id, count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
  nat_gateway_id         = "${element(var.nat_gateway_id, count.index)}"
  count                  = "${ length  (var.availability_zone) }"
}
