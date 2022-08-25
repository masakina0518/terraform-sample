variable "project_name" {}

variable "environment" {}

variable "engine" {
  default = "redis"
}

variable "node_type" {
  default = "cache.t2.micro"
}

variable "engine_version" {
  default = "5.0.6"
}

variable "parameter_group_name" {
  default = "default.redis5.0"
}

variable "number_cache_clusters" {
  default = 1
}

variable "subnet_group_name" {}

variable "security_group_ids" {
  default = []
}

variable "apply_immediately" {
  default = true
}
