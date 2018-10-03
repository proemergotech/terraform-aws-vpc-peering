provider "aws" {
  alias   = "peer"
  region  = "${var.peer_region}"
  profile = "${var.peer_profile}"
}

data "aws_caller_identity" "peer" {
  provider = "aws.peer"
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
  count = "${var.enabled ? var.peer_from_route_tables_count : 0}"

  route_table_id            = "${element(var.peer_from_route_tables, count.index)}"
  destination_cidr_block    = "${var.peer_to_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer_from_to_peer_to_vpc.id}"
}

resource "aws_route" "peer_to_to_peer_from" {
  count = "${var.enabled ? var.peer_to_route_tables_count : 0}"

  route_table_id            = "${element(var.peer_to_route_tables, count.index)}"
  destination_cidr_block    = "${var.peer_from_vpc_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer_from_to_peer_to_vpc.id}"
}
