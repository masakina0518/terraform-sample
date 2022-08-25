#デッドレターキュー
resource "aws_sqs_queue" "dlq" {
  name = "${var.project_name}-${var.environment}-${var.name}-dlq"

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.name}-dlq"
    Environment = var.environment
    Project     = var.project_name
    Role        = "${var.name}-dlq"
  }
}

#通常キュー
resource "aws_sqs_queue" "this" {
  name       = "${var.project_name}-${var.environment}-${var.name}"
  fifo_queue = var.fifo_queue
  #FIFOキューのコンテンツベースの重複性排除
  content_based_deduplication = var.fifo_queue
  #可視性タイムアウト
  visibility_timeout_seconds = var.visibility_timeout_seconds
  #メッセージ保持期間
  message_retention_seconds = var.message_retention_seconds
  #配信遅延
  delay_seconds = var.delay_seconds
  #最大メッセージサイズ
  max_message_size = var.max_message_size
  #メッセージ受信待機時間
  receive_wait_time_seconds = var.receive_wait_time_seconds

  #デッドレターキュー設定
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.maxReceiveCount
  })

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.name}"
    Environment = var.environment
    Project     = var.project_name
    Role        = var.name
  }
}
