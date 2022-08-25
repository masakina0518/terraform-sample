resource "aws_sns_topic" "this" {
  name = "${var.project_name}-${var.environment}-${var.name}"
  #未対応
  # fifo_topic                  = var.fifo_topic
  # content_based_deduplication = var.fifo_topic

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.name}"
    Environment = var.environment
    Project     = var.project_name
    Role        = var.name
  }
}
