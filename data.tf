data "aws_vpc" "peer_from_vpc" {
  count = "${var.enabled ? 1 : 0}"
  id = "${var.peer_from_vpc_id}"
}

data "aws_vpc" "peer_to_vpc" {
  count = "${var.enabled ? 1 : 0}"
  id = "${var.peer_to_vpc_id}"
}
