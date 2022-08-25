variable "project_name" {}

variable "environment" {}

variable "vpc_this" {}

locals {
  subnets = {
    public = {
      subnet-1a = {
        availability_zone = "ap-northeast-1a"
        cidr_block        = cidrsubnet(var.vpc_this.cidr_block, 8, 1)
      }
      subnet-1c = {
        availability_zone = "ap-northeast-1c"
        cidr_block        = cidrsubnet(var.vpc_this.cidr_block, 8, 2)
      }
      subnet-1d = {
        availability_zone = "ap-northeast-1d"
        cidr_block        = cidrsubnet(var.vpc_this.cidr_block, 8, 3)
      }
    }
    private = {
      subnet-1a = {
        availability_zone = "ap-northeast-1a"
        cidr_block        = cidrsubnet(var.vpc_this.cidr_block, 8, 11)
      }
      subnet-1c = {
        availability_zone = "ap-northeast-1c"
        cidr_block        = cidrsubnet(var.vpc_this.cidr_block, 8, 12)
      }
      subnet-1d = {
        availability_zone = "ap-northeast-1d"
        cidr_block        = cidrsubnet(var.vpc_this.cidr_block, 8, 13)
      }
    }
  }
}

