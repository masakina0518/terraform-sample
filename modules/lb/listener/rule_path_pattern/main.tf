#リスナーのルール作成
resource "aws_lb_listener_rule" "this" {
  listener_arn = var.lb_listener_this.arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.lb_target_group_this.arn
  }

  condition {
    path_pattern {
      values = var.condition_values
    }
  }
}
