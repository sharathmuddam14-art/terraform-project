#################################################
# Project
#################################################

variable "project_name" {

  description = "Project Name"

  type = string

}

variable "environment" {

  description = "Environment"

  type = string

}

variable "aws_region" {

  description = "AWS Region"

  type = string

}

#################################################
# Secret
#################################################

variable "secret_name" {

  description = "Secrets Manager Secret Name"

  type = string

}

variable "secret_description" {

  description = "Description of Secret"

  type = string

  default = "Managed by Terraform"

}

#################################################
# KMS
#################################################

variable "kms_key_id" {

  description = "KMS Key ARN"

  type = string

}

#################################################
# Secret Value
#################################################

variable "secret_value" {

  description = "Secret Value"

  type = string

  sensitive = true

}

#################################################
# Tags
#################################################

variable "tags" {

  type = map(string)

  default = {}

}
