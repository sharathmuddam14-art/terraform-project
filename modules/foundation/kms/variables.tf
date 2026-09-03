#################################################
# Project
#################################################

variable "project_name" {

  type = string

}

variable "environment" {

  type = string

}

variable "aws_region" {

  type = string

}

#################################################
# KMS
#################################################

variable "key_alias" {

  description = "KMS Alias"

  type = string

}

variable "deletion_window_in_days" {

  description = "Deletion Window"

  type = number

  default = 30

}

#################################################
# KMS Rotation
#################################################

variable "enable_key_rotation" {

  description = "Enable automatic KMS key rotation"

  type = bool

  default = true

}
