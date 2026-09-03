############################################################
# Project Information
############################################################

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

############################################################
# AWS Configuration
############################################################

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

############################################################
# Networking
############################################################

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "public_subnets" {

  description = "Public subnet configuration"

  type = map(object({

    cidr = string
    az   = string

  }))

}

variable "private_subnets" {

  description = "Private subnet configuration"

  type = map(object({

    cidr = string
    az   = string

  }))

}
############################################################
# Common Tags
############################################################

variable "tags" {

  description = "Common resource tags"

  type = map(string)

  default = {}


}


############################################################
# ECR REGISTRY SCAN TYPE
############################################################

variable "registry_scan_type" {

  description = "ECR registry scan type"

  type = string

}

############################################################
# ECR REGISTRY SCAN FREQUENCY
############################################################

variable "registry_scan_frequency" {

  description = "ECR registry scan frequency"

  type = string

}

############################################################
# ECR REPOSITORY FILTER
############################################################

variable "repository_filter" {

  description = "ECR repository filter"

  type = object({

    filter      = string
    filter_type = string

  })

}

############################################################
# ECR REPOSITORIES
############################################################

variable "repositories" {

  description = "ECR repository configuration"

  type = map(object({

    image_tag_mutability = string

    scan_on_push = bool

    encryption = object({

      type = string

      kms_key = optional(string)

    })

    lifecycle = object({

      enabled = bool

      untagged = object({

        priority     = number
        description  = string
        tag_status   = string
        count_type   = string
        count_unit   = string
        count_number = number
        action_type  = string

      })

      tagged = object({

        priority        = number
        description     = string
        tag_status      = string
        tag_prefix_list = list(string)
        count_type      = string
        count_number    = number
        action_type     = string

      })

    })

    repository_policy = object({

      enabled = bool

      version = string

      statement_id = string

      effect = string

      principals = list(string)

      actions = list(string)

    })

  }))

}

############################################################
# EKS CLUSTER
############################################################

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes Version"
  type        = string
}

############################################################
# API SERVER ACCESS
############################################################

variable "cluster_endpoint_public_access" {
  description = "Enable public endpoint"
  type        = bool
}

variable "cluster_endpoint_private_access" {
  description = "Enable private endpoint"
  type        = bool
}

############################################################
# CONTROL PLANE LOGGING
############################################################

variable "enabled_log_types" {

  description = "EKS control plane log types"

  type = list(string)

  default = [
    "api",
    "audit",
    "authenticator"
  ]
}

############################################################
# EKS NODE GROUPS
############################################################

variable "node_groups" {

  description = "Managed node groups"

  type = map(object({

    instance_types = list(string)

    capacity_type = string

    ami_type = string

    disk_size = number

    desired_size = number

    min_size = number

    max_size = number

    labels = optional(map(string), {})

    taints = optional(list(object({

      key = string

      value = string

      effect = string

    })), [])

  }))
}

############################################################
# EKS ADDONS
############################################################

variable "cluster_addons" {

  description = "EKS managed addons"

  type = map(object({

    version = optional(string)

    resolve_conflicts_on_create = optional(string)

    resolve_conflicts_on_update = optional(string)

    service_account_role_arn = optional(string)

  }))

  default = {}

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
# EKS CONTROL PLANE LOGGING
############################################################

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days"
  type        = number
}

############################################################
# EKS LAUNCH TEMPLATE
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
# EKS SECURITY GROUP
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
# EKS ACCESS ENTRY
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
# NOTE
############################################################
# Do NOT declare these variables here:
#
# vpc_iid
# private_subnet_ids
# public_subnet_ids
# kms_key_arn
#
# These values come from other modules:
#
# module.networking.vpc_id
# module.networking.private_subnet_ids
# module.networking.public_subnet_ids
# module.kms.key_arn
#
############################################################
############################################################
# KMS
############################################################

variable "key_alias" {
  description = "KMS key alias"
  type        = string
}

variable "deletion_window_in_days" {
  description = "KMS key deletion window"
  type        = number
  default     = 30
}
############################################################
# KARPENTER
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

variable "interruption_queue_name" {
  description = "Karpenter interruption queue name"
  type        = string
}

variable "rds" {

  description = "Production RDS configuration"

  type = object({

    identifier = string

    engine         = string
    engine_version = string

    instance_class = string

    allocated_storage     = number
    max_allocated_storage = number
    storage_type          = string

    storage_encrypted = bool

    db_name  = string
    username = string
    port     = number

    multi_az            = bool
    publicly_accessible = bool

    backup_retention_period = number
    backup_window           = string
    maintenance_window      = string

    copy_tags_to_snapshot    = bool
    delete_automated_backups = bool

    monitoring_interval                   = number
    performance_insights_enabled          = bool
    performance_insights_retention_period = number
    create_monitoring_role                = bool

    deletion_protection = bool
    skip_final_snapshot = bool

    parameter_group_family = string

    parameters = list(object({
      name         = string
      value        = string
      apply_method = optional(string, "immediate")
    }))

    security_group_name        = string
    security_group_description = string

    ingress_protocol = string

    egress_cidr     = string
    egress_protocol = string

    password_length      = number
    password_special     = bool
    password_min_lower   = number
    password_min_upper   = number
    password_min_numeric = number
    password_min_special = number

    secret_description = string
  })
}
variable "gateway_services" {
  description = "Gateway endpoint services"
  type        = set(string)
}

variable "gateway_endpoint_type" {
  description = "Gateway endpoint type"
  type        = string
}

variable "interface_services" {
  description = "Interface endpoint services"
  type        = set(string)
}

variable "interface_endpoint_type" {
  description = "Interface endpoint type"
  type        = string
}

variable "interface_private_dns_enabled" {
  description = "Private DNS setting for Interface endpoints"
  type        = bool
}

variable "interface_security_group_ids" {
  description = "Additional Interface endpoint security groups"
  type        = set(string)
}

variable "create_endpoint_security_group" {
  description = "Create endpoint security group"
  type        = bool
}

variable "endpoint_security_group_name" {
  description = "Endpoint security group name"
  type        = string
}

variable "endpoint_security_group_description" {
  description = "Endpoint security group description"
  type        = string
}

variable "endpoint_security_group_ingress_description" {
  description = "Endpoint security group ingress description"
  type        = string
}

variable "endpoint_security_group_ingress_from_port" {
  description = "Endpoint security group ingress from port"
  type        = number
}

variable "endpoint_security_group_ingress_to_port" {
  description = "Endpoint security group ingress to port"
  type        = number
}

variable "endpoint_security_group_ingress_protocol" {
  description = "Endpoint security group ingress protocol"
  type        = string
}

variable "endpoint_security_group_ingress_cidr_blocks" {
  description = "Endpoint security group ingress CIDRs"
  type        = set(string)
}

variable "endpoint_security_group_egress_from_port" {
  description = "Endpoint security group egress from port"
  type        = number
}

variable "endpoint_security_group_egress_to_port" {
  description = "Endpoint security group egress to port"
  type        = number
}

variable "endpoint_security_group_egress_protocol" {
  description = "Endpoint security group egress protocol"
  type        = string
}

variable "endpoint_security_group_egress_cidr_blocks" {
  description = "Endpoint security group egress CIDRs"
  type        = set(string)
}

variable "endpoint_tags" {
  description = "Endpoint tags"
  type        = map(string)
}

variable "endpoint_security_group_tags" {
  description = "Endpoint security group tags"
  type        = map(string)
}

