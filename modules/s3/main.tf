resource "aws_s3_bucket" "this" {
  bucket        = "${var.project_name}-${var.environment}-${var.bucket_role}-bucket"
  acl           = var.acl
  force_destroy = var.force_destroy

  tags = {
    Name        = "${var.project_name}-${var.environment}-${var.bucket_role}-bucket"
    Environment = var.environment
    Project     = var.project_name
    Role        = var.bucket_role
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
