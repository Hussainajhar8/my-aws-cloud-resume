module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "cloud_resume_counter_table_terraform"
  hash_key = "id"

  attributes = [
    {
      name  = "id"
      type  = "S"
    },
    {
      name  = "views"
      type  = "N"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "views-index"
      hash_key        = "views"
      projection_type = "INCLUDE"
      non_key_attributes = ["id"]  # Include "id" attribute in index
    }
  ]

  tags = local.common_tags
}

resource "aws_dynamodb_table_item" "id_item" {
  table_name = module.dynamodb_table.dynamodb_table_id
  hash_key   = "id"
  item = jsonencode({
    id    = {"S": "1"},
    views = {"N": "630"},
  })
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table."
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table."
  value       = module.dynamodb_table.dynamodb_table_id
}
