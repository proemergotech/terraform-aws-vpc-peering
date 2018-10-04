provider "aws" {
  alias = "accepter"
}

provider "aws" {
  alias = "requester"
}

data "aws_region" "accepter" {
  provider = "aws.accepter"
}

data "aws_vpc" "requester" {
  provider = "aws.requester"
  count    = "${var.enabled ? 1 : 0}"
  id       = "${var.requester_vpc_id}"
}

data "aws_vpc" "accepter" {
  provider = "aws.accepter"
  count    = "${var.enabled ? 1 : 0}"
  id       = "${var.accepter_vpc_id}"
}

resource "aws_vpc_peering_connection" "connection" {
  provider    = "aws.requester"
  count       = "${var.enabled ? 1 : 0}"
  peer_vpc_id = "${var.accepter_vpc_id}"
  vpc_id      = "${var.requester_vpc_id}"
  peer_region = "${data.aws_region.accepter.name}"
  auto_accept = "false"

  tags = "${merge(map("Comment", "Managed By Terraform"), var.tags)}"
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider = "aws.accepter"

  vpc_peering_connection_id = "${aws_vpc_peering_connection.connection.id}"
  auto_accept               = "${var.auto_accept}"

  tags = "${merge(map("Comment", "Managed By Terraform"), var.tags)}"
}

resource "aws_route" "requester_route" {
  provider = "aws.requester"
  count    = "${var.enabled ? "${var.requester_route_tables_count}" : 0}"

  route_table_id            = "${element(var.requester_route_tables, count.index)}"
  destination_cidr_block    = "${data.aws_vpc.accepter.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.connection.id}"
}

resource "aws_route" "accepter_route" {
  provider = "aws.accepter"
  count    = "${var.enabled ? "${var.accepter_route_tables_count}" : 0}"

  route_table_id            = "${element(var.accepter_route_tables, count.index)}"
  destination_cidr_block    = "${data.aws_vpc.requester.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.connection.id}"
}
