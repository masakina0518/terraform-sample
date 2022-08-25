resource "aws_sns_topic_subscription" "this" {
  topic_arn = var.sns_topic_this.arn
  protocol  = "sqs"
  endpoint  = var.sqs_queue_this.arn
}
