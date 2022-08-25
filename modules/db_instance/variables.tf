variable "project_name" {}

variable "environment" {}

variable "allocated_storage" {
  default = 5
}

variable "max_allocated_storage" {
  default = 100
}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {}

variable "instance_class" {
  default = "db.t2.micro"
}

variable "storage_type" {
  default = "gp2"
}

variable "name" {
  default = null
}

variable "username" {
  default = "admin"
}
variable "password" {
  default = "password"
}

variable "parameter_group_name" {}

variable "option_group_name" {}

variable "vpc_security_group_ids" {}

variable "subnet_group_name" {}

variable "auto_minor_version_upgrade" {
  default = true
}

variable "multi_az" {
  default = true
}

variable "storage_encrypted" {
  default = false
}

variable "backup_retention_period" {
  default = "7"
}

variable "backup_window" {
  default = "19:00-19:30"
}

variable "skip_final_snapshot" {
  default = true
}

variable "deletion_protection" {
  default = false
}
