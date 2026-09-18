variable "project_name" {

  type = string

}

variable "environment" {

  type = string

}

variable "aws_region" {

  type = string

}

variable "vpc_cidr" {

  type = string

}

variable "public_subnets" {

  type = map(object({

    cidr = string

    az = string

  }))

}

variable "private_subnets" {

  type = map(object({

    cidr = string

    az = string

  }))

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
# Common Tags
############################################################

variable "tags" {

  description = "Common resource tags"

  type = map(string)

  default = {}


}
############################################################
# EKS
############################################################

variable "cluster_name" {
  description = "Test EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Test EKS Kubernetes version"
  type        = string
}

variable "cluster_endpoint_private_access" {
  description = "Enable private EKS API endpoint access"
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Enable public EKS API endpoint access"
  type        = bool
}

variable "authentication_mode" {
  description = "EKS authentication mode"
  type        = string
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Grant cluster creator administrator permissions"
  type        = bool
}

variable "enabled_log_types" {
  description = "EKS control plane log types"
  type        = list(string)
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention period"
  type        = number
}

variable "node_groups" {
  description = "Test EKS managed node groups"

  type = map(object({

    instance_types = list(string)

    capacity_type = string

    desired_size = number

    min_size = number

    max_size = number

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

variable "cluster_addons" {
  description = "Test EKS cluster addons"

  type = map(object({

    version = optional(string)

    resolve_conflicts_on_create = optional(string)

    resolve_conflicts_on_update = optional(string)

    service_account_role_arn = optional(string)

  }))
}


############################################################
# EKS LAUNCH TEMPLATE
############################################################

variable "enable_launch_template" {
  description = "Enable EKS launch template"
  type        = bool
}

variable "root_volume_size" {
  description = "EKS node root volume size"
  type        = number
}

variable "root_volume_type" {
  description = "EKS node root volume type"
  type        = string
}

variable "root_volume_encrypted" {
  description = "Encrypt EKS node root volume"
  type        = bool
}

variable "delete_root_volume_on_termination" {
  description = "Delete EBS volume when node terminates"
  type        = bool
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 detailed monitoring"
  type        = bool
}

variable "imds_http_endpoint" {
  description = "EC2 IMDS HTTP endpoint"
  type        = string
}

variable "imds_http_tokens" {
  description = "EC2 IMDS token requirement"
  type        = string
}

variable "imds_hop_limit" {
  description = "EC2 IMDS hop limit"
  type        = number
}

variable "imds_instance_metadata_tags" {
  description = "EC2 IMDS instance metadata tags"
  type        = string
}
############################################################
# RDS CONFIGURATION
############################################################

variable "rds" {

  description = "RDS configuration"

  type = object({

    identifier     = string
    engine         = string
    engine_version = string

    db_name  = string
    username = string
    port     = number

    instance_class = string

    allocated_storage     = number
    max_allocated_storage = number
    storage_type          = string
    storage_encrypted     = bool

    multi_az            = bool
    publicly_accessible = bool

    backup_retention_period  = number
    backup_window            = string
    maintenance_window       = string
    copy_tags_to_snapshot    = bool
    delete_automated_backups = bool
    secret_description       = string

    deletion_protection = bool
    skip_final_snapshot = bool

    monitoring_interval                   = number
    performance_insights_enabled          = bool
    performance_insights_retention_period = number
    create_monitoring_role                = bool

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

############################################################
# EKS SECURITY GROUP VARIABLES
############################################################

variable "cluster_security_group_description" {
  description = "Description for the EKS cluster security group"
  type        = string
}

variable "node_security_group_description" {
  description = "Description for the EKS node security group"
  type        = string
}

variable "node_to_cluster_port" {
  description = "Port used for node to cluster communication"
  type        = number
}

variable "node_to_cluster_protocol" {
  description = "Protocol used for node to cluster communication"
  type        = string
}

variable "node_to_node_from_port" {
  description = "Starting port for node to node communication"
  type        = number
}

variable "node_to_node_to_port" {
  description = "Ending port for node to node communication"
  type        = number
}

variable "node_to_node_protocol" {
  description = "Protocol used for node to node communication"
  type        = string
}

variable "node_egress_cidr_blocks" {
  description = "CIDR blocks allowed for node egress"
  type        = list(string)
}

variable "cluster_egress_cidr_blocks" {
  description = "CIDR blocks allowed for cluster egress"
  type        = list(string)
}

############################################################
# EKS ACCESS VARIABLES
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
# AWS LOAD BALANCER CONTROLLER
############################################################

variable "load_balancer_controller_chart_version" {
  description = "AWS Load Balancer Controller Helm chart version"
  type        = string
}

variable "load_balancer_controller_replicas" {
  description = "Number of AWS Load Balancer Controller replicas"
  type        = number
}



variable "platform_alb_name" {
  description = "Platform ALB name"
  type        = string
}

variable "jenkins_enabled" {
  description = "Enable Jenkins"
  type        = bool
}

variable "nexus_enabled" {
  description = "Enable Nexus"
  type        = bool
}

variable "sonarqube_enabled" {
  description = "Enable SonarQube"
  type        = bool
}

variable "jenkins_java_version" {
  description = "Jenkins Java version"
  type        = string
}

variable "nexus_java_version" {
  description = "Nexus Java version"
  type        = string
}

variable "sonarqube_java_version" {
  description = "SonarQube Java version"
  type        = string
}

variable "jenkins_port" {
  description = "Jenkins application port"
  type        = number
}

variable "nexus_port" {
  description = "Nexus application port"
  type        = number
}

variable "sonarqube_port" {
  description = "SonarQube application port"
  type        = number
}

variable "jenkins_instance_type" {
  description = "Jenkins EC2 instance type"
  type        = string
}

variable "nexus_instance_type" {
  description = "Nexus EC2 instance type"
  type        = string
}

variable "sonarqube_instance_type" {
  description = "SonarQube EC2 instance type"
  type        = string
}

variable "jenkins_root_volume_size" {
  description = "Jenkins root volume size"
  type        = number
}

variable "nexus_root_volume_size" {
  description = "Nexus root volume size"
  type        = number
}

variable "sonarqube_root_volume_size" {
  description = "SonarQube root volume size"
  type        = number
}

variable "jenkins_package" {
  description = "Jenkins package to install"
  type        = string
}

variable "nexus_version" {
  description = "Nexus version"
  type        = string
}

variable "sonarqube_version" {
  description = "SonarQube version"
  type        = string
}

variable "sonarqube_db_name" {
  description = "SonarQube PostgreSQL database name"
  type        = string
}

variable "sonarqube_db_user" {
  description = "SonarQube PostgreSQL database username"
  type        = string
}
variable "jenkins_ami_id" {
  description = "AMI ID for Jenkins EC2 instance"
  type        = string
  default     = null
}

variable "nexus_ami_id" {
  description = "AMI ID for Nexus EC2 instance"
  type        = string
  default     = null
}
