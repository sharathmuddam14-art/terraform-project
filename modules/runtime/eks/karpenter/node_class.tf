############################################################
# KARPENTER EC2 NODE CLASS
############################################################

resource "kubectl_manifest" "node_class" {

  yaml_body = yamlencode({

    apiVersion = "karpenter.k8s.aws/v1"

    kind = "EC2NodeClass"

    metadata = {
      name = var.node_class_name
    }

    spec = {

      amiFamily = var.node_ami_family

      amiSelectorTerms = [
        {
          alias = var.node_ami_alias
        }
      ]

      role = var.node_role_arn

      subnetSelectorTerms = [
        for subnet_id in var.private_subnet_ids : {
          id = subnet_id
        }
      ]

      securityGroupSelectorTerms = [
        {
          id = var.node_security_group_id
        }
      ]

      tags = merge(
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
  })

  depends_on = [
    helm_release.karpenter
  ]
}
