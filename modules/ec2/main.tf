
resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami_id
  subnet_id              = local.subnets.public[count.index % length(local.subnets.public)]
  instance_type          = var.instance_type
  monitoring             = var.environment == "production" ? true : false
  vpc_security_group_ids = [var.security_group_this.id]
  key_name               = var.key_pair_this.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.instance_role}-${count.index}"
    Environment = var.environment
    Project     = var.project_name
    Role        = var.instance_role
  }
}
