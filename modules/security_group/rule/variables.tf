variable "security_group_this" {}

variable "type" {}

variable "cidr_blocks" {
  default = ["0.0.0.0/0"]
}

variable "from_port" {}

variable "to_port" {}

variable "protocol" {
  default = "tcp"
}
