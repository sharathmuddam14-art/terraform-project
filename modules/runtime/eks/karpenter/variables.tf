############################################################
# EKS
############################################################

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "EKS cluster CA certificate"
  type        = string
}

############################################################
# OIDC
############################################################

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  type        = string
}

variable "oidc_issuer_url" {
  description = "EKS OIDC issuer URL"
  type        = string
}

############################################################
# NETWORK
############################################################

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Karpenter nodes"
  type        = list(string)
}

variable "node_security_group_id" {
  description = "EKS node security group ID"
  type        = string
}

############################################################
# NODE IAM
############################################################

variable "node_role_arn" {
  description = "EKS node IAM role ARN"
  type        = string
}

############################################################
# KARPENTER HELM
############################################################

variable "karpenter_namespace" {
  description = "Karpenter Kubernetes namespace"
  type        = string
}

variable "karpenter_chart_repository" {
  description = "Karpenter Helm OCI repository"
  type        = string
}

variable "karpenter_chart_name" {
  description = "Karpenter Helm chart name"
  type        = string
}

variable "karpenter_chart_version" {
  description = "Karpenter Helm chart version"
  type        = string
}

variable "controller_cpu_request" {
  description = "Karpenter controller CPU request"
  type        = string
}

variable "controller_memory_request" {
  description = "Karpenter controller memory request"
  type        = string
}

############################################################
# NODE CLASS
############################################################

variable "node_class_name" {
  description = "Karpenter EC2NodeClass name"
  type        = string
}

variable "node_ami_family" {
  description = "Karpenter AMI family"
  type        = string
}

variable "node_ami_alias" {
  description = "Karpenter AMI selector alias"
  type        = string
}

############################################################
# NODE POOL
############################################################

variable "node_pool_name" {
  description = "Karpenter NodePool name"
  type        = string
}

variable "node_architecture" {
  description = "Karpenter node architecture"
  type        = string
}

variable "node_capacity_type" {
  description = "Karpenter capacity type"
  type        = string
}

############################################################
# INTERRUPTION QUEUE
############################################################

variable "interruption_queue_name" {
  description = "Karpenter interruption queue name"
  type        = string
}

############################################################
# TAGS
############################################################

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}
