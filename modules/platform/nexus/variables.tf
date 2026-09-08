variable "name" {
  description = "Nexus instance name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ALB security group ID"
  type        = string
}

variable "instance_type" {
  description = "Nexus EC2 instance type"
  type        = string
}

variable "root_volume_size" {
  description = "Nexus root volume size"
  type        = number
}

variable "ami_id" {
  description = "Optional AMI ID"
  type        = string
  default     = null
}

variable "java_version" {
  description = "Java version"
  type        = string
}

variable "nexus_version" {
  description = "Nexus version"
  type        = string
}

variable "nexus_port" {
  description = "Nexus application port"
  type        = number
}
