provider "aws" {
  alias = "us-east-1"
}

module "acm" {
  source = "terraform-aws-modules/acm/aws"

  providers = {
    aws = aws.us-east-1
  }

  domain_name = var.domain_names[0]
  zone_id     = var.cloudflare_zone_id

  subject_alternative_names = slice(var.domain_names, 1, 4)

  create_route53_records  = false

  wait_for_validation = true

  # validation_record_fqdns = 

  tags = local.common_tags
}