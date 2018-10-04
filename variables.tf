variable "requester_vpc_id" {
  type = "string"

  description = "The VPC to peer from."
}

variable "requester_route_tables_count" {
  type = "string"

  description = "List of route tables from the peer_from VPC"
}

variable "requester_route_tables" {
  type = "list"

  description = "List of route tables from the peer_from VPC"
}

variable "accepter_vpc_id" {
  type = "string"

  description = "The VPC ID to peer to."
}

variable "accepter_route_tables_count" {
  type = "string"

  description = "List of route tables from the peer to VPC."
}

variable "accepter_route_tables" {
  type = "list"

  description = "List of route tables from the peer to VPC."
}

variable "auto_accept" {
  type = "string"

  description = "Specify whether or not connections should be automatically accepted"

  default = true
}

variable "enabled" {
  default = true
}
