#HTTPリスナーの作成(とALBとターゲットグループのひも付け)
resource "aws_lb_listener" "http" {
  load_balancer_arn = var.lb_this.arn
  port              = "80"
  protocol          = "HTTP"

  # default_action {
  #   target_group_arn = var.lb_target_group_this.arn
  #   type             = "forward"
  # }

  # 443 redirect
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#HTTPSリスナーの作成(とALBとターゲットグループのひも付け)
resource "aws_lb_listener" "https" {
  load_balancer_arn = var.lb_this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = var.lb_target_group_this.arn
    type             = "forward"
  }
}
