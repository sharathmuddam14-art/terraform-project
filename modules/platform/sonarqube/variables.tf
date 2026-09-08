variable "name" {
  description = "SonarQube instance name"
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
  description = "SonarQube EC2 instance type"
  type        = string
}

variable "root_volume_size" {
  description = "SonarQube root volume size"
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

variable "sonarqube_version" {
  description = "SonarQube version"
  type        = string
}

variable "sonarqube_port" {
  description = "SonarQube port"
  type        = number
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
}

variable "db_user" {
  description = "PostgreSQL database username"
  type        = string
}
