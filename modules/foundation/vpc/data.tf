#################################################
# Current AWS Region
#################################################

data "aws_region" "current" {}

#################################################
# Current AWS Account
#################################################

data "aws_caller_identity" "current" {}

#################################################
# Available Availability Zones
#################################################

data "aws_availability_zones" "available" {
  state = "available"
}
