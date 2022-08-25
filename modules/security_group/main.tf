resource "aws_security_group" "this" {
  name   = "${var.project_name}-${var.environment}-${var.security_group_role}-group"
  vpc_id = var.vpc_this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.security_group_role}-security_group"
    Environment = var.environment
    Project     = var.project_name
  }
}
