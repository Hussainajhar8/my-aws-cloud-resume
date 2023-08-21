# Purpose: Create Cloudfront distribution for API Gateway
resource "aws_cloudfront_distribution" "api_gateway" {
  depends_on = [module.api_gateway, module.acm, module.zone]
  
  aliases = [var.domain_names[3]]
  enabled             = true
  is_ipv6_enabled     = false
  retain_on_delete    = false
  wait_for_deployment = false
  comment             = "Api-gateway CDN using Terraform"
  price_class         = "PriceClass_All"

  origin {
    domain_name              = replace(module.api_gateway.apigatewayv2_api_api_endpoint, "https://", "") # replacing because cloudfront origin domain name does not accept https://
    custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1.2"]
    }
    origin_id                = replace(module.api_gateway.apigatewayv2_api_api_endpoint, "https://", "")
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = replace(module.api_gateway.apigatewayv2_api_api_endpoint, "https://", "")
    cache_policy_id = data.aws_cloudfront_cache_policy.default.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.default.id
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
}

data "aws_cloudfront_origin_request_policy" "default" {
  name = "Managed-AllViewer"
}

data "aws_cloudfront_cache_policy" "default" {
  #name = "Managed-CachingOptimized"
  name = "Managed-CachingDisabled"
}

# -------------------------------------------------------------------------------------------------- from cloudfront_module.tf (old)

# module "cdn" {
#   source = "terraform-aws-modules/cloudfront/aws"

#   aliases = [var.domain_names[3]]


#   enabled             = true
#   is_ipv6_enabled     = false
#   price_class         = "PriceClass_100"
#   retain_on_delete    = false
#   wait_for_deployment = false
#   comment             = "Api-gateway CDN using Terraform"

#   origin = {
#     api_gateway = {
#       domain_name = module.api_gateway.apigatewayv2_domain_name_target_domain_name
#       origin_id   = module.api_gateway.apigatewayv2_domain_name_target_domain_name
#       custom_origin_config = {
#         http_port              = 80
#         https_port             = 443
#         origin_protocol_policy = "match-viewer"
#         origin_ssl_protocols   = ["TLSv1.2"]
#       }
#     }
#   }

#   default_cache_behavior = {
#     target_origin_id           = module.api_gateway.apigatewayv2_domain_name_target_domain_name
#     viewer_protocol_policy     = "redirect-to-https"

#     allowed_methods = ["GET", "HEAD", "OPTIONS"]
#     cached_methods  = ["GET", "HEAD", "OPTIONS"]
#     compress        = true
#     query_string    = true
#   }

#   viewer_certificate = {
#     acm_certificate_arn = module.acm.acm_certificate_arn
#     ssl_support_method  = "sni-only"
#   }
# }

# #--------------------------------------------------------------- Outputs ---------------------------------------------------------------

# output "cloudfront_distribution_arn" {
#   description = "The ARN (Amazon Resource Name) for the distribution."
#   value       = module.cdn.cloudfront_distribution_arn
# }

# output "cloudfront_distribution_caller_reference" {
#   description = "Internal value used by CloudFront to allow future updates to the distribution configuration."
#   value       = module.cdn.cloudfront_distribution_caller_reference
# }

# output "cloudfront_distribution_domain_name" {
#   description = "The domain name corresponding to the distribution."
#   value       = module.cdn.cloudfront_distribution_domain_name
# }

# output "cloudfront_distribution_id" {
#   description = "The identifier for the distribution."
#   value       = module.cdn.cloudfront_distribution_id
# }