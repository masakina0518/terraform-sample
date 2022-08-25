variable "project_name" {}

variable "environment" {}

variable "bucket_role" {}

variable "acl" {
  default = "private"
}

variable "force_destroy" {
  default = true
}

variable "block_public_acls" {
  default = true
}

variable "block_public_policy" {
  default = true
}

variable "ignore_public_acls" {
  default = true
}

variable "restrict_public_buckets" {
  default = true
}
