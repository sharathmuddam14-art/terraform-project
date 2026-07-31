#################################################
# Project Information
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
# Networking
#################################################

variable "vpc_cidr" {

  description = "VPC CIDR"

  type = string

}

#################################################
# Public Subnets
#################################################

variable "public_subnets" {

  description = "Public Subnets"

  type = map(object({

    cidr = string

    az = string

  }))

}

#################################################
# Private Subnets
#################################################

variable "private_subnets" {

  description = "Private Subnets"

  type = map(object({

    cidr = string

    az = string

  }))
}
