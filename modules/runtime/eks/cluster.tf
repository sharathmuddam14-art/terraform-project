############################################################
# EKS CLUSTER
############################################################

resource "aws_eks_cluster" "this" {

  name     = local.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  version = var.cluster_version

  access_config {

    authentication_mode = var.authentication_mode

    bootstrap_cluster_creator_admin_permissions = (
      var.bootstrap_cluster_creator_admin_permissions
    )
  }

  ##########################################################
  # NETWORK
  ##########################################################

  vpc_config {

    subnet_ids = var.private_subnet_ids

    endpoint_private_access = (
      var.cluster_endpoint_private_access
    )

    endpoint_public_access = (
      var.cluster_endpoint_public_access
    )

    security_group_ids = [
      aws_security_group.cluster.id
    ]
  }

  ##########################################################
  # KMS ENCRYPTION
  ##########################################################

  encryption_config {

    provider {
      key_arn = var.kms_key_arn
    }

    resources = [
      "secrets"
    ]
  }

  ##########################################################
  # CONTROL PLANE LOGGING
  ##########################################################

  enabled_cluster_log_types = var.enabled_log_types

  ##########################################################
  # DEPENDENCIES
  ##########################################################

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_vpc_controller
  ]

  tags = local.common_tags
}
