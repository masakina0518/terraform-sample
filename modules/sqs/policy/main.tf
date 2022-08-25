# SNSにSQSアクセス権を与えるポリシー
resource "aws_sqs_queue_policy" "this" {
  queue_url = var.sqs_queue_this.id

  policy = templatefile(
    "${path.module}/policy.json",
    {
      sqs_arn = var.sqs_queue_this.arn,
      sns_arn = var.sns_topic_this.arn
    }
  )
}
