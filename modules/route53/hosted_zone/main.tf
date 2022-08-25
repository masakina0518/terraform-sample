resource "aws_route53_zone" "this" {
  name = var.name

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.name}"
    Environment = var.environment
    Project     = var.project_name
  }
}
