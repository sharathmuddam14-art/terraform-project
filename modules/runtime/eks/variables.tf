############################################################
# CLUSTER
############################################################

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
}

############################################################
# NETWORKING
############################################################

variable "vpc_id" {
  description = "VPC ID where EKS will be created"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

############################################################
# EKS API ACCESS
############################################################

variable "cluster_endpoint_private_access" {
  description = "Enable private EKS API endpoint access"
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Enable public EKS API endpoint access"
  type        = bool
}

############################################################
# EKS AUTHENTICATION
############################################################

variable "authentication_mode" {
  description = "EKS authentication mode"
  type        = string
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Grant cluster creator administrator permissions"
  type        = bool
}

############################################################
# CONTROL PLANE LOGGING
############################################################

variable "enabled_log_types" {
  description = "EKS control plane log types"
  type        = list(string)
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days"
  type        = number
}

############################################################
# KMS
############################################################

variable "kms_key_arn" {
  description = "KMS key ARN used for EKS encryption"
  type        = string
}

############################################################
# NODE GROUPS
############################################################

variable "node_groups" {
  description = "EKS managed node groups"

  type = map(object({
    instance_types = list(string)
    capacity_type  = string

    desired_size = number
    min_size     = number
    max_size     = number

    disk_size = number

    ami_type = optional(string)

    labels = optional(map(string), {})

    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))
}

############################################################
# LAUNCH TEMPLATE
############################################################

variable "enable_launch_template" {
  description = "Enable custom launch template"
  type        = bool
}

variable "root_volume_size" {
  description = "Root EBS volume size"
  type        = number
}

variable "root_volume_type" {
  description = "Root EBS volume type"
  type        = string
}

variable "root_volume_encrypted" {
  description = "Encrypt root EBS volume"
  type        = bool
}

variable "delete_root_volume_on_termination" {
  description = "Delete root EBS volume when instance terminates"
  type        = bool
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 detailed monitoring"
  type        = bool
}

variable "imds_http_endpoint" {
  description = "EC2 IMDS endpoint setting"
  type        = string
}

variable "imds_http_tokens" {
  description = "EC2 IMDS token requirement"
  type        = string
}

variable "imds_hop_limit" {
  description = "EC2 IMDS response hop limit"
  type        = number
}

variable "imds_instance_metadata_tags" {
  description = "Enable instance metadata tags"
  type        = string
}

############################################################
# SECURITY GROUP
############################################################

variable "cluster_security_group_description" {
  description = "EKS cluster security group description"
  type        = string
}

variable "node_security_group_description" {
  description = "EKS node security group description"
  type        = string
}

variable "node_to_cluster_port" {
  description = "Port used from nodes to EKS cluster"
  type        = number
}

variable "node_to_cluster_protocol" {
  description = "Protocol used from nodes to EKS cluster"
  type        = string
}

variable "node_to_node_from_port" {
  description = "Node-to-node starting port"
  type        = number
}

variable "node_to_node_to_port" {
  description = "Node-to-node ending port"
  type        = number
}

variable "node_to_node_protocol" {
  description = "Node-to-node protocol"
  type        = string
}

variable "node_egress_cidr_blocks" {
  description = "Node egress CIDR blocks"
  type        = list(string)
}

variable "cluster_egress_cidr_blocks" {
  description = "Cluster egress CIDR blocks"
  type        = list(string)
}

############################################################
# ACCESS ENTRY
############################################################

variable "access_entry_type" {
  description = "EKS access entry type"
  type        = string
}

variable "access_policy_arn" {
  description = "EKS access policy ARN"
  type        = string
}

variable "access_scope_type" {
  description = "EKS access scope type"
  type        = string
}

############################################################
# ADDONS
############################################################

variable "cluster_addons" {
  description = "EKS addons"

  type = map(object({
    version                     = optional(string)
    resolve_conflicts_on_create = optional(string)
    resolve_conflicts_on_update = optional(string)
    service_account_role_arn    = optional(string)
  }))
}

############################################################
# TAGS
############################################################

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
