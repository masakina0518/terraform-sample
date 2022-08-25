# auto scaling group
resource "aws_autoscaling_group" "this" {
  name                      = "${var.project_name}-${var.environment}-${var.instance_role}-group"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = var.launch_configuration_this.id
  # 対象サブネット
  vpc_zone_identifier = local.subnets.public
  # LBターゲットグループ
  target_group_arns = [var.lb_target_group_this.arn]

  # 起動時にインスタンスに付与するタグ
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-${var.instance_role}-auto"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = var.instance_role
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
