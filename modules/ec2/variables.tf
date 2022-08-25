variable "project_name" {}

variable "environment" {}

variable "instance_count" {}

variable "instance_role" {}

variable "ami_id" {}

variable "instance_type" {}

variable "security_group_this" {}

variable "key_pair_this" {}

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

