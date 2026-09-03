locals {

  name_prefix = "${var.cluster_name}-karpenter"

  common_tags = merge(
    var.tags,
    {
      ManagedBy = lookup(
        var.tags,
        "ManagedBy",
        "Terraform"
      )
    }
  )
}
