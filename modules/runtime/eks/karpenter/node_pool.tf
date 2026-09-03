############################################################
# KARPENTER NODE POOL
############################################################

resource "kubectl_manifest" "node_pool" {

  yaml_body = yamlencode({

    apiVersion = "karpenter.sh/v1"

    kind = "NodePool"

    metadata = {
      name = var.node_pool_name
    }

    spec = {

      template = {

        spec = {

          nodeClassRef = {

            name = var.node_class_name

            group = "karpenter.k8s.aws"

            kind = "EC2NodeClass"
          }

          requirements = [

            {
              key = "kubernetes.io/arch"

              operator = "In"

              values = [
                var.node_architecture
              ]
            },

            {
              key = "karpenter.sh/capacity-type"

              operator = "In"

              values = [
                var.node_capacity_type
              ]
            }
          ]
        }
      }
    }
  })

  depends_on = [
    kubectl_manifest.node_class
  ]
}
