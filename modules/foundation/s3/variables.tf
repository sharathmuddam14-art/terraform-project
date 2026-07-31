#################################################
# Project Information
#################################################

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

#################################################
# Bucket
#################################################

variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

#################################################
# Encryption
#################################################

variable "kms_key_arn" {
  description = "KMS Key ARN"
  type        = string
}

#################################################
# Tags
#################################################

variable "tags" {
  description = "Common Tags"

  type = map(string)

  default = {}
}
