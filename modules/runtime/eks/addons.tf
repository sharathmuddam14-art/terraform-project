############################################################
# EKS MANAGED ADDONS
############################################################

resource "aws_eks_addon" "this" {

  for_each = var.cluster_addons

  cluster_name = aws_eks_cluster.this.name

  addon_name = each.key

  addon_version = try(
    each.value.version,
    null
  )

  resolve_conflicts_on_create = try(
    each.value.resolve_conflicts_on_create,
    null
  )

  resolve_conflicts_on_update = try(
    each.value.resolve_conflicts_on_update,
    null
  )

  service_account_role_arn = each.key == "aws-ebs-csi-driver" ? aws_iam_role.ebs_csi.arn : try(
    each.value.service_account_role_arn,
    null
  )

  tags = local.common_tags

  depends_on = [
    aws_eks_cluster.this
  ]
}
