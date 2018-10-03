variable "peer_from_vpc_id" {
  type = "string"

  description = "The VPC to peer from."
}

variable "peer_to_vpc_id" {
  type = "string"

  description = "The VPC ID to peer to."
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
