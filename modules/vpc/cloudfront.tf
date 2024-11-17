provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

data "aws_cloudfront_cache_policy" "disabled_cache_policy" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "optimized_cache_policy" {
  name = "Managed-CachingOptimized"
}

data "aws_acm_certificate" "route53_certificate" {
  provider = aws.us-east-1
  domain   = "*.route-53-test.link"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_distribution" "distribution" {
  aliases             = ["*.route-53-test.link"]
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  staging             = false
  tags                = { Name = "weijie-test" }
  wait_for_deployment = true
  #   Cache 404 error for 100s
  custom_error_response {
    error_caching_min_ttl = 100
    error_code            = 404
    response_code         = 0
    response_page_path    = null
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.disabled_cache_policy.id
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    target_origin_id       = aws_lb.alb.dns_name
    viewer_protocol_policy = "allow-all"
  }
  ordered_cache_behavior {
    allowed_methods           = ["GET", "HEAD"]
    cache_policy_id           = data.aws_cloudfront_cache_policy.optimized_cache_policy.id
    cached_methods            = ["GET", "HEAD"]
    compress                  = true
    default_ttl               = 0
    field_level_encryption_id = null
    max_ttl                   = 0
    min_ttl                   = 0
    # origin_request_policy_id   = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    path_pattern           = "/*.js"
    target_origin_id       = aws_lb.alb.dns_name
    viewer_protocol_policy = "allow-all"
  }
  ordered_cache_behavior {
    allowed_methods           = ["GET", "HEAD"]
    cache_policy_id           = data.aws_cloudfront_cache_policy.optimized_cache_policy.id
    cached_methods            = ["GET", "HEAD"]
    compress                  = true
    default_ttl               = 0
    field_level_encryption_id = null
    max_ttl                   = 0
    min_ttl                   = 0
    # origin_request_policy_id   = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    path_pattern           = "/*.css"
    target_origin_id       = aws_lb.alb.dns_name
    viewer_protocol_policy = "allow-all"
  }
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = aws_lb.alb.dns_name
    origin_id           = aws_lb.alb.dns_name
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:479833041972:certificate/800ba313-4db1-4e8a-b016-76d34a2ffd1e" //note that this needs to be in us-east-1
    cloudfront_default_certificate = false
    iam_certificate_id             = null
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
