# s3 バケットアクセスに利用するオリジンアクセスIDの生成
# resource "aws_cloudfront_origin_access_identity" "this" {
#   comment = "${var.project_name}-${var.environment}-id"
# }

resource "aws_cloudfront_distribution" "this" {
  enabled         = true
  comment         = "${var.project_name}-${var.environment}-cf"
  is_ipv6_enabled = false
  price_class     = "PriceClass_200"
  aliases         = var.aliases
  # waf
  #web_acl_id =

  #lb
  origin {
    domain_name = var.lb_this.dns_name
    origin_id   = local.lb_origin_id

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "https-only"
      origin_keepalive_timeout = 5
      origin_read_timeout      = 60
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = local.lb_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    forwarded_values {
      query_string = true
      # cloudfront →　lb間でwhitelist設定しないと502返ってくる
      headers = ["Host", "Authorization"]
      cookies {
        forward = "all"
      }
    }
  }

  #3
  # origin {
  #   #domain_name = var.lb_this.dns_name
  #   #origin_id = var.lb_this.origin_id

  # }

  # ordered_cache_behavior {

  # }

  # custom_error_response {

  # }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # logging_config {
  #   include_cookies = false
  #   bucket          = var.log_backet.bucket_domain_name
  #   prefix          = "cloudfront/${var.project_name}-${var.environment}-web"
  # }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cf"
    Environment = var.environment
    Project     = var.project_name
  }
}
