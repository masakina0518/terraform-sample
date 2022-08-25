resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db_subnet_group"
  subnet_ids = [var.subnets.subnet-1a.id, var.subnets.subnet-1c.id, var.subnets.subnet-1d.id]

  tags = {
    Name        = "${var.project_name}-${var.environment}-db_subnet_group"
    Environment = var.environment
    Project     = var.project_name
  }
}
