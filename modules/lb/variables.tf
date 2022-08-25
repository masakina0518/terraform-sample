variable "project_name" {}

variable "environment" {}

variable "load_balancer_type" {}

variable "vpc_this" {}

variable "security_group_this" {}

variable "public_subnets" {}

locals {
  subnets = {
    public = [
      var.public_subnets.subnet-1a.id,
      var.public_subnets.subnet-1c.id,
      var.public_subnets.subnet-1d.id,
    ]
  }
}
