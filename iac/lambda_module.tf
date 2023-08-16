module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

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
  }

  tags = local.common_tags
}

output "lambda_function_url" {
  description = "value of the lambda function url"
  value       = module.lambda_function.lambda_function_url
  
}