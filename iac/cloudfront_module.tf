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