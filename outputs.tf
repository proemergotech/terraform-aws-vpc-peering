output "peering_connection_id" {
  value = "${join("", aws_vpc_peering_connection.connection.*.id)}"
}
