############################################################
# EKS MANAGED NODE GROUPS
############################################################

resource "aws_eks_node_group" "this" {

  for_each = var.node_groups

  ##########################################################
  # BASIC CONFIGURATION
  ##########################################################

  cluster_name = aws_eks_cluster.this.name

  node_group_name = each.key

  node_role_arn = aws_iam_role.eks_node.arn

  subnet_ids = var.private_subnet_ids

  ##########################################################
  # SCALING
  ##########################################################

  scaling_config {

    desired_size = each.value.desired_size

    min_size = each.value.min_size

    max_size = each.value.max_size
  }

  ##########################################################
  # INSTANCE
  ##########################################################

  instance_types = each.value.instance_types

  capacity_type = each.value.capacity_type

  ami_type = try(
    each.value.ami_type,
    null
  )

  ##########################################################
  # LAUNCH TEMPLATE
  ##########################################################

  dynamic "launch_template" {

    for_each = (
      var.enable_launch_template
      ? [1]
      : []
    )

    content {

      id = aws_launch_template.this[0].id

      version = (
        aws_launch_template.this[0].latest_version
      )
    }
  }

  ##########################################################
  # LABELS
  ##########################################################

  labels = try(
    each.value.labels,
    {}
  )

  ##########################################################
  # TAINTS
  ##########################################################

  dynamic "taint" {

    for_each = try(
      each.value.taints,
      []
    )

    content {

      key = taint.value.key

      value = taint.value.value

      effect = taint.value.effect
    }
  }

  ##########################################################
  # DEPENDENCIES
  ##########################################################

  depends_on = [

    aws_eks_cluster.this,

    aws_iam_role_policy_attachment.worker_node,

    aws_iam_role_policy_attachment.cni,

    aws_iam_role_policy_attachment.ecr_pull,

    aws_iam_role_policy_attachment.ssm
  ]

  tags = local.common_tags
}
