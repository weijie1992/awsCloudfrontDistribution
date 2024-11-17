data "aws_route53_zone" "this" {
  name         = "route-53-test.link"
  private_zone = false
}

resource "aws_route53_record" "myrecord" {
  name           = "cloudfront.route-53-test.link"
  set_identifier = null
  type           = "A"
  zone_id        = data.aws_route53_zone.this.id
  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
  }
}
