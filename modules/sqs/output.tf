output "sqs_queue_this" {
  value = aws_sqs_queue.this
}

output "sqs_queue_dlq" {
  value = aws_sqs_queue.dlq
}
