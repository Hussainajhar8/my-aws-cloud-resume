module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "ajhar-cloud-resume-terraform-${local.environment}"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = false
  }
}

# resource "aws_s3_bucket_versioning" "configuration" {
#   depends_on = [module.s3_bucket]
#   bucket = module.s3_bucket.s3_bucket_id

#   versioning_configuration {
#     status = "Disabled"
#   }
# }

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  depends_on = [module.s3_bucket]
  bucket = module.s3_bucket.s3_bucket_id

  rule {
    bucket_key_enabled = true
  }
}
# No longer needed since I have a seperate ci/cd pipeline for the front end
resource "aws_s3_object" "upload" {
  depends_on = [module.s3_bucket]
  for_each   = fileset("../front_end/", "**")
  bucket     = module.s3_bucket.s3_bucket_id
  key        = each.value
  source     = "../front_end/${each.value}"
  etag       = filemd5("../front_end/${each.value}")
}

resource "aws_s3_bucket_policy" "cloudfront_s3_bucket_policy" {
  depends_on = [aws_cloudfront_distribution.s3_distribution , module.s3_bucket]
  bucket     = module.s3_bucket.s3_bucket_id
  policy = jsonencode({
          "Version": "2008-10-17",
          "Id": "PolicyForCloudFrontPrivateContent",
          "Statement": [
              {
                  "Sid": "AllowCloudFrontServicePrincipal",
                  "Effect": "Allow",
                  "Principal": {
                      "Service": "cloudfront.amazonaws.com"
                  },
                  "Action": "s3:GetObject",
                  "Resource": format("%s/*", module.s3_bucket.s3_bucket_arn),
                  "Condition": {
                      "StringEquals": {
                        "AWS:SourceArn": aws_cloudfront_distribution.s3_distribution.arn
                      }
                  }
              }
          ]
        })
}

#--------------------------------------------------------------- Outputs ---------------------------------------------------------------

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = module.s3_bucket.s3_bucket_arn
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

output "s3_bucket_bucket_regional_domain_name" {
  description = "The bucket region_specific domain name. The bucket domain name including the region name, please refer here for format."
  value       = module.s3_bucket.s3_bucket_bucket_regional_domain_name
}

output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = module.s3_bucket.s3_bucket_id
}


output "s3_bucket_policy" {
  depends_on = [ aws_s3_bucket_policy.cloudfront_s3_bucket_policy ]
  description = "The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string."
  value       = module.s3_bucket.s3_bucket_policy
}

output "s3_bucket_region" {
  description = "The AWS region this bucket resides in."
  value       = module.s3_bucket.s3_bucket_region
}
