resource "aws_route_table" "this" {
  vpc_id = var.vpc_this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.route_table_role}-route_table"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_route_table_association" "this" {
  for_each       = var.subnets
  subnet_id      = var.subnets[each.key].id
  route_table_id = aws_route_table.this.id
}
