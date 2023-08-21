# Creates records for DNS validation

module "zone" {
  source  = "cloudposse/zone/cloudflare"
  version = "0.5.1"
  account_id = var.cloudflare_account_id
  zone_enabled = false
  zone       = var.domain_names[0]
  records = [
    for option in module.acm.acm_certificate_domain_validation_options :
    {
      name  = option.resource_record_name
      type  = option.resource_record_type
      value = option.resource_record_value
      ttl   = 3600
      count = var.existing_records[option.resource_record_name] ? 0 : 1
    }
  ]
}


# Terraform Cloudflare Records for domain names
resource "cloudflare_record" "cloudfront_redirect" {
  depends_on = [ aws_cloudfront_distribution.s3_distribution, module.acm ]
  zone_id = var.cloudflare_zone_id
  name    = var.domain_names[0]
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "cloudfront_redirect_2" {
  depends_on = [ aws_cloudfront_distribution.s3_distribution, module.acm ]
  zone_id = var.cloudflare_zone_id
  name    = var.domain_names[1]
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "cloudfront_redirect_3" {
  depends_on = [ aws_cloudfront_distribution.s3_distribution, module.acm ]
  zone_id = var.cloudflare_zone_id
  name    = var.domain_names[2]
  value   = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"
  ttl     = 3600
}

resource "cloudflare_record" "cloudfront_redirect_4" {
  depends_on = [ aws_cloudfront_distribution.api_gateway, module.acm ]
  zone_id = var.cloudflare_zone_id
  name    = var.domain_names[3]
  value   = aws_cloudfront_distribution.api_gateway.domain_name
  type    = "CNAME"
  ttl     = 3600
}
