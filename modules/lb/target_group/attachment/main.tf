#ターゲットグループとインスタンスまたはコンテナとひも付け
resource "aws_lb_target_group_attachment" "this" {
  count            = length(var.aws_instance_this)
  target_group_arn = var.lb_target_group_this.arn
  target_id        = var.aws_instance_this[count.index].id
  port             = 80
}
