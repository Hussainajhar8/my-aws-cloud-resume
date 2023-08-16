# Input variables
#
# AWS Region
variable "aws_region" {
  description = "Region in which AWS resources will be created "
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = list
  default     = ["test", "prod"]
}

variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "IT"
}

variable "domain_names" {
  description = "value of the domain names"
  type        = list(string)
  default     = ["ajharresume.com", "www.ajharresume.com", "cloud.ajharresume.com", "lambda.ajharresume.com"]
  
}