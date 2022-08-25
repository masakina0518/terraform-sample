variable "project_name" {}

variable "environment" {}

variable "instance_role" {}

variable "launch_configuration_this" {}

variable "lb_target_group_this" {}

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

