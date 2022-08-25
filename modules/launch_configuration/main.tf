# auto scaling 起動設定
resource "aws_launch_configuration" "this" {
  name                        = "${var.project_name}-${var.environment}-${var.instance_role}-auto-scaling"
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_this.key_name
  security_groups             = [var.security_group_this.id]
  associate_public_ip_address = true
  enable_monitoring           = var.environment == "production" ? true : false

  lifecycle {
    create_before_destroy = true
  }
}
