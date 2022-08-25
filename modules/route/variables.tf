variable "route_table_this" {}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "nat_gateway_this" {
  default = null
}

variable "igw_this" {
  default = null
}
