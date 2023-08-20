# Define Local Values in Terraform
locals {
  owners      = var.business_division
  environment = var.environment[1]
  
  name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
} 