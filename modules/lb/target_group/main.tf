#ターゲットグループの作成
resource "aws_lb_target_group" "this" {
  name     = "${var.project_name}-${var.environment}-${var.terget_group_role}-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_this.id

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 3
    matcher             = 200
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.terget_group_role}-target_group"
    Environment = var.environment
    Project     = var.project_name
    Role        = var.terget_group_role
  }
}
