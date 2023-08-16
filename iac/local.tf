# Define Local Values in Terraform
locals {
  owners      = var.business_division
  environment = var.environment[0]
  
  name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
} 