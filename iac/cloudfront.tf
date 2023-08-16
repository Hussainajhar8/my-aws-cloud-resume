resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [module.s3_bucket, module.acm]
  
  aliases = var.domain_names
  enabled             = true
  is_ipv6_enabled     = false
  retain_on_delete    = false
  wait_for_deployment = false
  comment             = "Cloud resume via CloudFront using Terraform"
  default_root_object = "templates/index.html"
  price_class         = "PriceClass_100"

  origin {
    domain_name              = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = module.s3_bucket.s3_bucket_bucket_regional_domain_name
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    cache_policy_id = data.aws_cloudfront_cache_policy.default.id
    viewer_protocol_policy = "redirect-to-https"
    compress            = true
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = local.common_tags

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# -------------------------------------------------------------------------------------------------- from cloudfront_module.tf

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = module.s3_bucket.s3_bucket_bucket_regional_domain_name
  description                       = "Control policy for CloudFront to access S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "no-override"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "default" {
  #name = "Managed-CachingOptimized"
  name = "Managed-CachingDisabled"
}
