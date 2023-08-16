resource "cloudflare_record" "cloudfront_redirect" {
  depends_on = [ aws_cloudfront_distribution.s3_distribution ]
  zone_id = var.cloudflare_zone_id
  name    = var.domain_names[0]
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "cloudfront_redirect_2" {
  depends_on = [ aws_cloudfront_distribution.s3_distribution ]
  zone_id = var.cloudflare_zone_id
  name    = var.domain_names[1]
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "cloudfront_redirect_3" {
  depends_on = [ aws_cloudfront_distribution.s3_distribution ]
  zone_id = var.cloudflare_zone_id
  name    = var.domain_names[2]
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"
  ttl     = 3600
}

# resource "cloudflare_record" "cloudfront_redirect_4" {
#   depends_on = [ aws_cloudfront_distribution.s3_distribution ]
#   zone_id = var.cloudflare_zone_id
#   name    = var.domain_names[3]
#   value   = aws_cloudfront_distribution.s3_distribution.domain_name
#   type    = "CNAME"
#   ttl     = 3600
# }
