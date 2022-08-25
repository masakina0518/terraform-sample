resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-${var.environment}-ssh_key"
  public_key = var.ssh_key_path
}
