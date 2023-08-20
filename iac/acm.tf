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


#--------------------------------------------------------------- Outputs ---------------------------------------------------------------

output "acm_certificate_arn" {
  description = "The ARN of the certificate."
  value       = module.acm.acm_certificate_arn
}

output "acm_certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used."
  value       = module.acm.acm_certificate_domain_validation_options
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = module.acm.acm_certificate_status
}

output "distinct_domain_names" {
  description = "List of distinct domain names used for the validation."
  value       = module.acm.distinct_domain_names
}
