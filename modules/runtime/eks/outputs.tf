############################################################
# CLUSTER OUTPUTS
############################################################

output "cluster_name" {

  description = "EKS cluster name"

  value = aws_eks_cluster.this.name
}

output "cluster_arn" {

  description = "EKS cluster ARN"

  value = aws_eks_cluster.this.arn
}

output "cluster_endpoint" {

  description = "EKS API endpoint"

  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {

  description = "EKS cluster CA certificate"

  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_version" {

  description = "EKS Kubernetes version"

  value = aws_eks_cluster.this.version
}

############################################################
# OIDC
############################################################

output "oidc_provider_arn" {

  description = "OIDC provider ARN"

  value = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_issuer_url" {

  description = "OIDC issuer URL"

  value = aws_iam_openid_connect_provider.eks.url
}

############################################################
# NODE
############################################################

output "node_role_name" {

  description = "EKS node IAM role name"

  value = aws_iam_role.eks_node.name
}

output "node_role_arn" {

  description = "EKS node IAM role ARN"

  value = aws_iam_role.eks_node.arn
}

############################################################
# SECURITY GROUPS
############################################################

output "cluster_security_group_id" {

  description = "EKS cluster security group ID"

  value = aws_security_group.cluster.id
}

output "node_security_group_id" {

  description = "EKS node security group ID"

  value = aws_security_group.node.id
}

############################################################
# IRSA
############################################################

output "ebs_csi_role_arn" {

  description = "EBS CSI driver IAM role ARN"

  value = aws_iam_role.ebs_csi.arn
}

output "alb_controller_role_arn" {

  description = "AWS Load Balancer Controller IAM role ARN"

  value = aws_iam_role.alb_controller.arn
}
############################################################
# EKS CLUSTER OUTPUTS
############################################################



output "cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

############################################################
# OIDC OUTPUTS
############################################################
output "oidc_provider_url" {
  description = "EKS OIDC provider URL"
  value       = aws_iam_openid_connect_provider.eks.url
}
