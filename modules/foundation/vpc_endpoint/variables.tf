variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "gateway_services" {
  description = "AWS Gateway endpoint services"
  type        = set(string)
}

variable "gateway_endpoint_type" {
  description = "Endpoint type used for Gateway endpoints"
  type        = string
}

variable "gateway_route_table_ids" {
  description = "Route table IDs associated with Gateway endpoints"
  type        = set(string)
}

variable "interface_services" {
  description = "AWS Interface endpoint services"
  type        = set(string)
}

variable "interface_endpoint_type" {
  description = "Endpoint type used for Interface endpoints"
  type        = string
}

variable "interface_subnet_ids" {
  description = "Subnet IDs associated with Interface endpoints"
  type        = set(string)
}

variable "interface_security_group_ids" {
  description = "Additional security group IDs for Interface endpoints"
  type        = set(string)
}

variable "interface_private_dns_enabled" {
  description = "Whether private DNS is enabled for Interface endpoints"
  type        = bool
}

variable "create_endpoint_security_group" {
  description = "Whether to create the Interface endpoint security group"
  type        = bool
}

variable "endpoint_security_group_name" {
  description = "Name of the Interface endpoint security group"
  type        = string
}

variable "endpoint_security_group_description" {
  description = "Description of the Interface endpoint security group"
  type        = string
}

variable "endpoint_security_group_ingress_description" {
  description = "Description of the endpoint security group ingress rule"
  type        = string
}

variable "endpoint_security_group_ingress_from_port" {
  description = "Ingress starting port"
  type        = number
}

variable "endpoint_security_group_ingress_to_port" {
  description = "Ingress ending port"
  type        = number
}

variable "endpoint_security_group_ingress_protocol" {
  description = "Ingress protocol"
  type        = string
}

variable "endpoint_security_group_ingress_cidr_blocks" {
  description = "Ingress CIDR blocks"
  type        = set(string)
}

variable "endpoint_security_group_egress_from_port" {
  description = "Egress starting port"
  type        = number
}

variable "endpoint_security_group_egress_to_port" {
  description = "Egress ending port"
  type        = number
}

variable "endpoint_security_group_egress_protocol" {
  description = "Egress protocol"
  type        = string
}

variable "endpoint_security_group_egress_cidr_blocks" {
  description = "Egress CIDR blocks"
  type        = set(string)
}

variable "endpoint_tags" {
  description = "Tags applied to VPC endpoints"
  type        = map(string)
}

variable "endpoint_security_group_tags" {
  description = "Tags applied to endpoint security group"
  type        = map(string)
}
