resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-cache"
  subnet_ids = [var.subnets.subnet-1a.id, var.subnets.subnet-1c.id, var.subnets.subnet-1d.id]
}
