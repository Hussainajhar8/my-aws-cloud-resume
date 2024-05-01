module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  version = "6.8.0"

  function_name = "cloud_resume_api_terraform"
  description   = "api to get and modify visitor counter from dynamodb table"
  handler       = "counter_api.lambda_handler"
  runtime       = "python3.11"

  source_path = "${path.module}/lambda/counter_api.py"

  attach_policy_jsons = true

  number_of_policy_jsons = 3

  policy_jsons = [
    file("lambda/lambda_policy.json"),
    file("lambda/dynamodb_policy.json"),
    file("lambda/cloudfront_policy.json")
  ]

  create_lambda_function_url = true

  cors = {
    allow_origins = formatlist("https://%s", var.domain_names)
    allow_methods     = ["*"]
    allow_headers     = ["content-type"]
  }

  tags = local.common_tags
}

resource "aws_lambda_permission" "execution_lambda_from_gateway" {
    statement_id  = "AllowExecutionFromAPIGateway"
    action        = "lambda:InvokeFunction"
    function_name = module.lambda_function.lambda_function_name
    principal     = "apigateway.amazonaws.com"
    source_arn = format("%s/*", module.api_gateway.apigatewayv2_api_execution_arn)
}

#--------------------------------------------------------------- Outputs ---------------------------------------------------------------

output "lambda_function_url" {
  description = "value of the lambda function url"
  value       = module.lambda_function.lambda_function_url
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function."
  value       = module.lambda_function.lambda_function_arn
}

output "lambda_function_name" {
  description = "The name of the Lambda Function."
  value       = module.lambda_function.lambda_function_name
}
