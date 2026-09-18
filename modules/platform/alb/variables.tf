variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "alb_name" {
  description = "Application Load Balancer name"
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
  description = "Jenkins port"
  type        = number
}

variable "nexus_port" {
  description = "Nexus port"
  type        = number
}

variable "sonarqube_port" {
  description = "SonarQube port"
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
  description = "Jenkins package"
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
  description = "SonarQube database name"
  type        = string
}

variable "sonarqube_db_user" {
  description = "SonarQube database username"
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
