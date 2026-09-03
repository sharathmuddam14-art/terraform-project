

############################################################
# AWS REGION
############################################################

data "aws_region" "current" {}

############################################################
# AWS PARTITION
############################################################

data "aws_partition" "current" {}


############################################################
# CURRENT AWS CALLER IDENTITY
############################################################

data "aws_caller_identity" "current" {}
data "aws_iam_role" "terraform" {
  name = split("/", data.aws_caller_identity.current.arn)[1]
}
