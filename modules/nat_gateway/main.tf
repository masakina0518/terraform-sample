resource "aws_nat_gateway" "this" {
  subnet_id     = var.subnet.id
  allocation_id = var.eip_this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.nat_role}"
    Environment = var.environment
    Project     = var.project_name
    Role        = var.nat_role
  }
}
