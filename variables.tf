variable "peer_from_vpc_name" {
  type = "string"

  description = "Name for the peer_from VPC."
}

variable "peer_from_vpc_id" {
  type = "string"

  description = "The VPC to peer from."
}

variable "peer_from_vpc_cidr" {
  type = "string"

  description = "The cidr block of the VPC to peer from."
}

variable "peer_from_route_tables_count" {
  type = "string"

  description = "List of route tables from the peer_from VPC"
}

variable "peer_from_route_tables" {
  type = "list"

  description = "List of route tables from the peer_from VPC"
}

variable "peer_to_vpc_name" {
  type = "string"

  description = "Name for the peer_to VPC."
}

variable "peer_to_vpc_id" {
  type = "string"

  description = "The VPC ID to peer to."
}

variable "peer_to_vpc_cidr" {
  type = "string"

  description = "The cidr block of the VPC to peer to."
}

variable "peer_to_route_tables_count" {
  type = "string"

  description = "List of route tables from the peer to VPC."
}

variable "peer_to_route_tables" {
  type = "list"

  description = "List of route tables from the peer to VPC."
}

variable "peer_region" {
  type = "string"

  description = "Region of the peer VPC provider."
}

variable "peer_profile" {
  type = "string"

  description = "Profile of the peer VPC provider."
}

variable "auto_accept" {
  type = "string"

  description = "Specify whether or not connections should be automatically accepted"

  default = true
}

variable "enabled" {
  default = true
}
