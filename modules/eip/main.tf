resource "aws_eip" "this" {
  vpc = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.eip_role}"
    Environment = var.environment
    Project     = var.project_name
    Role        = var.eip_role
  }
}
