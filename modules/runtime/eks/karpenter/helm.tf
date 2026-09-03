############################################################
# KARPENTER HELM RELEASE
############################################################

resource "helm_release" "karpenter" {

  name = var.node_pool_name

  namespace = var.karpenter_namespace

  create_namespace = true

  repository = var.karpenter_chart_repository

  chart = var.karpenter_chart_name

  version = var.karpenter_chart_version

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.controller.arn
  }

  set {
    name = "controller.resources.requests.cpu"

    value = var.controller_cpu_request
  }

  set {
    name = "controller.resources.requests.memory"

    value = var.controller_memory_request
  }

  depends_on = [
    aws_iam_role_policy_attachment.controller
  ]
}
