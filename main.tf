provider "aws" {
  alias   = "peer"
  region  = "${var.peer_region}"
  profile = "${var.peer_profile}"
}

data "aws_caller_identity" "peer" {
  provider = "aws.peer"
}

data "aws_vpc" "peer_from_vpc" {
  provider = "aws.peer"
  count    = "${var.enabled ? 1 : 0}"
  id       = "${var.peer_from_vpc_id}"
}

data "aws_vpc" "peer_to_vpc" {
  provider = "aws.peer"
  count    = "${var.enabled ? 1 : 0}"
  id       = "${var.peer_to_vpc_id}"
}

data "aws_route_tables" "peer_from_route_tables" {
  provider = "aws.peer"
  vpc_id   = "${var.peer_from_vpc_id}"
}

data "aws_route_tables" "peer_to_route_tables" {
  provider = "aws.peer"
  vpc_id   = "${var.peer_to_vpc_id}"
}

resource "aws_vpc_peering_connection" "peer_from_to_peer_to_vpc" {
  count       = "${var.enabled ? 1 : 0}"
  peer_vpc_id = "${var.peer_to_vpc_id}"
  vpc_id      = "${var.peer_from_vpc_id}"
  peer_region = "${var.peer_region}"
  auto_accept = "false"

  tags = {
    Name    = "${var.peer_from_vpc_id} to ${var.peer_to_vpc_id}"
    Comment = "Managed By Terraform"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider = "aws.peer"

  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer_from_to_peer_to_vpc.id}"
  auto_accept               = "${var.auto_accept}"

  tags = {
    Comment = "Managed By Terraform"
  }
}

resource "aws_route" "peer_from_to_peer_to" {
  #  count = "${length(var.peer_from_route_tables)}"
  count = "${var.enabled ? "${length(data.aws_route_tables.peer_from_route_tables)}" : 0}"

  route_table_id            = "${element(data.aws_route_tables.peer_from_route_tables, count.index)}"
  destination_cidr_block    = "${data.aws_vpc.peer_to_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer_from_to_peer_to_vpc.id}"
}

resource "aws_route" "peer_to_to_peer_from" {
  count = "${var.enabled ? "${length(data.aws_route_tables.peer_to_route_tables)}" : 0}"

  route_table_id            = "${element(data.aws_route_tables.peer_to_route_tables, count.index)}"
  destination_cidr_block    = "${data.aws_vpc.peer_from_vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer_from_to_peer_to_vpc.id}"
}
