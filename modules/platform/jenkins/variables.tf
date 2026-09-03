variable "name" {
  description = "Jenkins instance name"
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
  description = "Jenkins EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Jenkins EBS volume size"
  type        = number
  default     = 30
}

variable "ami_id" {
  description = "Optional custom AMI"
  type        = string
  default     = null
}
