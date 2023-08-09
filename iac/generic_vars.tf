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
  type        = string
  default     = "prod"
}

variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "IT"
}