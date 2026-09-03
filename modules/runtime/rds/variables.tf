############################################################
# PROJECT
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
# NETWORKING
############################################################

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

############################################################
# DATABASE
############################################################

variable "identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "RDS master username"
  type        = string
}

variable "password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
}

############################################################
# INSTANCE
############################################################

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

############################################################
# STORAGE
############################################################

variable "allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum autoscaling storage in GB"
  type        = number
}

variable "storage_type" {
  description = "RDS storage type"
  type        = string
}

variable "storage_encrypted" {
  description = "Enable RDS storage encryption"
  type        = bool
}

variable "kms_key_arn" {
  description = "KMS key ARN used for RDS encryption"
  type        = string
}

############################################################
# NETWORK ACCESS
############################################################

variable "multi_az" {
  description = "Enable Multi-AZ"
  type        = bool
}

variable "publicly_accessible" {
  description = "Make RDS publicly accessible"
  type        = bool
}

############################################################
# SECURITY GROUP
############################################################

variable "security_group_name" {
  description = "RDS security group name"
  type        = string
}

variable "security_group_description" {
  description = "RDS security group description"
  type        = string
}

variable "allowed_security_group_ids" {
  description = "Security groups allowed to access RDS"
  type        = list(string)
}

variable "ingress_protocol" {
  description = "RDS ingress protocol"
  type        = string
}

variable "egress_cidr" {
  description = "RDS egress CIDR"
  type        = string
}

variable "egress_protocol" {
  description = "RDS egress protocol"
  type        = string
}

############################################################
# BACKUP
############################################################

variable "backup_retention_period" {
  description = "RDS backup retention period"
  type        = number
}

variable "backup_window" {
  description = "RDS backup window"
  type        = string
}

variable "maintenance_window" {
  description = "RDS maintenance window"
  type        = string
}

variable "copy_tags_to_snapshot" {
  description = "Copy tags to RDS snapshots"
  type        = bool
}

variable "delete_automated_backups" {
  description = "Delete automated backups when RDS is deleted"
  type        = bool
}

############################################################
# MONITORING
############################################################

variable "monitoring_interval" {
  description = "Enhanced monitoring interval"
  type        = number
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention period"
  type        = number
}

variable "create_monitoring_role" {
  description = "Create IAM role for RDS Enhanced Monitoring"
  type        = bool
}

############################################################
# DELETION
############################################################

variable "deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS"
  type        = bool
}

############################################################
# PARAMETER GROUP
############################################################

variable "parameter_group_family" {
  description = "RDS parameter group family"
  type        = string
}

variable "parameters" {
  description = "RDS custom parameters"

  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))

  default = []
}

############################################################
# TAGS
############################################################

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}
