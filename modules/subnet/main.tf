resource "aws_subnet" "public_subnets" {
  for_each                = local.subnets.public
  vpc_id                  = var.vpc_this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public_subnet"
    Environment = var.environment
    Project     = var.project_name
    Tier        = "public"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each          = local.subnets.private
  vpc_id            = var.vpc_this.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name        = "${var.project_name}-${var.environment}-private_subnet"
    Environment = var.environment
    Project     = var.project_name
    Tier        = "private"
  }
}
