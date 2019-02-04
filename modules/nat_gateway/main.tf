variable "subnet_ids" {
  description = "Subnet IDs"
  type        = "list"
}

variable "availability_zone" {
  type = "list"
}

resource "aws_eip" "eip" {
  vpc   = true
  count = "${length(var.availability_zone)}"
}

resource "aws_nat_gateway" "nat-gw" {
  subnet_id     = "${element(var.subnet_ids, count.index)}"
  allocation_id = "${aws_eip.eip.*.id[count.index]}"

  tags {
    Name = "${ format("ngw-%s", element(var.availability_zone, count.index) ) }"
  }

  count = "${ length  (var.availability_zone) }"
}

output "ids" {
  value = ["${ aws_nat_gateway.nat-gw.*.id }"]
}
