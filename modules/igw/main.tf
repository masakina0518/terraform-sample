resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project_name
  }
}
