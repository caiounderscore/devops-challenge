variable "route_table_id" {
  description = "Route Table ID"
  type        = "list"
}

variable "destination_cidr_block" {
  description = "Destination Target"
}

variable "gateway_id" {
  description = "Gateway Target ID"
}

variable "tag_name" {
  type = "list"
}

variable "availability_zone" {
  description = "AZ"
  type        = "list"
}

resource "aws_route" "route" {
  route_table_id         = "${element(var.route_table_id, count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${var.gateway_id}"
  count                  = "${ length  (var.availability_zone) }"
}
