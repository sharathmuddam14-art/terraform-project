############################################################
# VPC OUTPUTS
############################################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  value = module.vpc.nat_gateway_public_ips
}

############################################################
# ECR OUTPUTS
############################################################

output "ecr_repository_names" {
  description = "ECR repository names"
  value       = module.ecr.repository_names
}

output "ecr_repository_urls" {
  description = "ECR repository URLs"
  value       = module.ecr.repository_urls
}

output "ecr_repository_arns" {
  description = "ECR repository ARNs"
  value       = module.ecr.repository_arns
}

output "ecr_registry_ids" {
  description = "ECR registry IDs"
  value       = module.ecr.repository_registry_ids
}

############################################################
# EKS OUTPUTS
############################################################

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_arn" {
  description = "EKS Cluster ARN"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Cluster CA Certificate"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_version" {
  description = "Cluster Kubernetes Version"
  value       = module.eks.cluster_version
}

############################################################
# OIDC OUTPUTS
############################################################

output "oidc_provider_arn" {
  description = "OIDC Provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "oidc_issuer_url" {
  description = "OIDC Issuer URL"
  value       = module.eks.oidc_issuer_url
}

############################################################
# NODE OUTPUTS
############################################################

output "node_role_name" {
  description = "Node IAM Role Name"
  value       = module.eks.node_role_name
}

output "node_role_arn" {
  description = "Node IAM Role ARN"
  value       = module.eks.node_role_arn
}

output "cluster_security_group_id" {
  description = "Cluster Security Group ID"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Node Security Group ID"
  value       = module.eks.node_security_group_id
}

############################################################
# IRSA OUTPUTS
############################################################

output "ebs_csi_role_arn" {
  description = "EBS CSI Driver Role ARN"
  value       = module.eks.ebs_csi_role_arn
}

output "alb_controller_role_arn" {
  description = "ALB Controller Role ARN"
  value       = module.eks.alb_controller_role_arn
}

############################################################
# KARPENTER OUTPUTS
############################################################

output "karpenter_role_arn" {
  description = "Karpenter IAM Role ARN"
  value       = module.karpenter.karpenter_role_arn
}


output "queue_name" {
  description = "Karpenter Interruption Queue"
  value       = module.karpenter.queue_name
}
