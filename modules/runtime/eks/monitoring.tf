############################################################
# CLOUDWATCH LOG GROUP
############################################################

resource "aws_cloudwatch_log_group" "eks" {

  name = "/aws/eks/${local.cluster_name}/cluster"

  retention_in_days = var.log_retention_in_days

  kms_key_id = var.kms_key_arn

  tags = local.common_tags
}
