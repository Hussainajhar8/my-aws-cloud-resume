module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"
  version = "2.1.0"

  name          = "terraform_lambda_api_gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_origins     = formatlist("https://%s", var.domain_names)
    allow_methods     = ["*"]
    allow_headers     = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token"]
  }

  create_api_domain_name           = true

  # Custom domain
  domain_name                 = var.domain_names[3]
  domain_name_certificate_arn = module.acm.acm_certificate_arn

  # Routes and integrations
  integrations = {
    "ANY /" = {
      integration_type = "AWS_PROXY"
      integration_method = "ANY"
      resource_path = "/"
      route_key = "/"
      payload_format_version = "2.0"
      lambda_arn             = module.lambda_function.lambda_function_arn
      integration_target = module.lambda_function.lambda_function_name
    }

    format("ANY /%s", module.lambda_function.lambda_function_name) = {
      integration_type = "AWS_PROXY"
      integration_method = "ANY"
      resource_path = format("ANY /%s", module.lambda_function.lambda_function_name)
      route_key = "/"
      payload_format_version = "2.0"
      lambda_arn             = module.lambda_function.lambda_function_arn
      integration_target = module.lambda_function.lambda_function_name
    }
  }

  tags = local.common_tags
}

#--------------------------------------------------------------- Outputs ---------------------------------------------------------------

output "apigatewayv2_api_api_endpoint" {
  description = "The URI of the API."
  value       = module.api_gateway.apigatewayv2_api_api_endpoint
}

output "apigatewayv2_api_arn" {
  description = "The ARN of the API."
  value       = module.api_gateway.apigatewayv2_api_arn
}

output "apigatewayv2_api_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = module.api_gateway.apigatewayv2_api_execution_arn
}

output "apigatewayv2_api_id" {
  description = "The API identifier."
  value       = module.api_gateway.apigatewayv2_api_id
}

output "apigatewayv2_api_mapping_id" {
  description = "The API mapping identifier."
  value       = module.api_gateway.apigatewayv2_api_mapping_id
}


output "apigatewayv2_domain_name_arn" {
  description = "The ARN of the domain name."
  value       = module.api_gateway.apigatewayv2_domain_name_arn
}

output "apigatewayv2_domain_name_configuration" {
  description = "The domain name configuration."
  value       = module.api_gateway.apigatewayv2_domain_name_configuration
}

output "apigatewayv2_domain_name_id" {
  description = "The domain name identifier."
  value       = module.api_gateway.apigatewayv2_domain_name_id
}

output "apigatewayv2_domain_name_target_domain_name" {
  description = "The target domain name."
  value       = module.api_gateway.apigatewayv2_domain_name_target_domain_name
}





