#ALBの作成
resource "aws_lb" "this" {
  name                       = "${var.project_name}-${var.environment}-lb"
  load_balancer_type         = var.load_balancer_type
  security_groups            = [var.security_group_this.id]
  subnets                    = local.subnets.public
  internal                   = false
  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Name        = "${var.project_name}-${var.environment}-lb"
    Environment = var.environment
    Project     = var.project_name
    Type        = var.load_balancer_type
  }
}
