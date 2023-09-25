resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [module.s3_bucket, module.acm, module.zone]
  
  aliases = slice(var.domain_names, 0, 3)
  enabled             = true
  is_ipv6_enabled     = false
  retain_on_delete    = false
  wait_for_deployment = false
  comment             = "S3 CDN using Terraform"
  default_root_object = "templates/index.html"
  price_class         = "PriceClass_All"

  origin {
    domain_name              = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = module.s3_bucket.s3_bucket_bucket_regional_domain_name
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    cache_policy_id = data.aws_cloudfront_cache_policy.optimized.id
    viewer_protocol_policy = "redirect-to-https"
    compress            = true
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none" # "whitelist"
      locations        = []#["US", "CA", "GB", "DE"]
    }
  }

  tags = local.common_tags

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  
  # Create invalidation after deployment
  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${self.id} --paths /static/assets/* "
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

data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}


# -------------------------------------------------------------------------------------------------- from cloudfront_module.tf (old)

# module "cdn" {
#   depends_on = [module.s3_bucket, module.acm]
#   source     = "terraform-aws-modules/cloudfront/aws"

#   aliases = var.domain_names

#   comment                       = "Cloud resume via CloudFront using Terraform"
#   enabled                       = true
#   is_ipv6_enabled               = false
#   price_class                   = "PriceClass_100"
#   retain_on_delete              = false
#   wait_for_deployment           = false
#   create_origin_access_identity = false
#   create_origin_access_control  = false
#   default_root_object           = "templates/index.html"

#   origin = {
#     s3_one = {
#       domain_name              = module.s3_bucket.s3_bucket_bucket_regional_domain_name
#       origin_id                = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    
#       origin_access_control_id = aws_cloudfront_origin_access_control.default.id
#     }
#   }

#   default_cache_behavior = {
#     # cache_policy_id = data.aws_cloudfront_cache_policy.default.id
#     target_origin_id = module.s3_bucket.s3_bucket_bucket_regional_domain_name
#     viewer_protocol_policy = "redirect-to-https"

#     allowed_methods = ["GET", "HEAD", "OPTIONS"]
#     cached_methods  = ["GET", "HEAD", "OPTIONS"]
#     compress        = true
#     query_string    = true
#   }

#   # ordered_cache_behavior = [
#   #   {
#   #     path_pattern           = "*"
#   #     cache_policy_id = data.aws_cloudfront_cache_policy.default.id
#   #     target_origin_id       = module.s3_bucket.s3_bucket_id
#   #     viewer_protocol_policy = "redirect-to-https"
#   #     forwarded_values = {
#   #       query_string = false
#   #       cookies      = false
#   #     }

#   #     allowed_methods = ["GET", "HEAD", "OPTIONS"]
#   #     cached_methods  = ["GET", "HEAD", "OPTIONS"]
#   #   }
#   # ]

#   viewer_certificate = {
#     cloudfront_default_certificate = true
#     acm_certificate_arn = module.acm.acm_certificate_arn
#     ssl_support_method = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2021"
#   }
# }

# #--------------------------------------------------------------- Outputs ---------------------------------------------------------------

# output "cloudfront_distribution_arn" {
#   description = "The ARN (Amazon Resource Name) for the distribution."
#   value       = module.cdn.cloudfront_distribution_arn
# }

# output "cloudfront_distribution_domain_name" {
#   description = "The domain name corresponding to the distribution."
#   value       = module.cdn.cloudfront_distribution_domain_name
# }

# output "cloudfront_distribution_id" {
#   description = "The identifier for the distribution."
#   value       = module.cdn.cloudfront_distribution_id
# }