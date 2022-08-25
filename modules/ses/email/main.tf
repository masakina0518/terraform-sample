resource "aws_ses_email_identity" "this" {
  for_each = zipmap(range(length(var.emails)), var.emails)
  email    = each.value
}
