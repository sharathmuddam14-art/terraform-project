####################################################
# VPC Outputs
####################################################

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

####################################################
# Public Subnets
####################################################

output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = values(aws_subnet.public)[*].id
}

output "public_subnet_arns" {
  description = "ARNs of all public subnets"
  value       = values(aws_subnet.public)[*].arn
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of all public subnets"
  value       = values(aws_subnet.public)[*].cidr_block
}

####################################################
# Private Subnets
####################################################

output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = values(aws_subnet.private)[*].id
}

output "private_subnet_arns" {
  description = "ARNs of all private subnets"
  value       = values(aws_subnet.private)[*].arn
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of all private subnets"
  value       = values(aws_subnet.private)[*].cidr_block
}

####################################################
# Internet Gateway
####################################################

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

####################################################
# Elastic IPs
####################################################

output "nat_eip_ids" {
  description = "Elastic IP Allocation IDs"
  value       = values(aws_eip.nat)[*].id
}

output "nat_gateway_public_ips" {
  description = "Public IPs of NAT Gateways"
  value       = values(aws_eip.nat)[*].public_ip
}

####################################################
# NAT Gateways
####################################################

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = values(aws_nat_gateway.nat)[*].id
}

####################################################
# Route Tables
####################################################

output "public_route_table_id" {
  description = "Public Route Table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private Route Table IDs"
  value       = values(aws_route_table.private)[*].id
}

####################################################
# Availability Zones
####################################################

output "availability_zones" {
  description = "Availability Zones used"
  value = distinct(concat(
    values(aws_subnet.public)[*].availability_zone,
    values(aws_subnet.private)[*].availability_zone
  ))
}

####################################################
# Summary
####################################################

output "network_summary" {
  description = "Summary of the network"

  value = {
    vpc_id              = aws_vpc.main.id
    public_subnets      = values(aws_subnet.public)[*].id
    private_subnets     = values(aws_subnet.private)[*].id
    internet_gateway_id = aws_internet_gateway.igw.id
    nat_gateways        = values(aws_nat_gateway.nat)[*].id
  }
}
####################################################
# VPC Endpoints
####################################################

output "s3_vpc_endpoint_id" {
  description = "S3 Gateway Endpoint ID"
  value       = aws_vpc_endpoint.s3.id
}

output "dynamodb_vpc_endpoint_id" {
  description = "DynamoDB Gateway Endpoint ID"
  value       = aws_vpc_endpoint.dynamodb.id
}

output "ssm_vpc_endpoint_id" {
  description = "SSM Interface Endpoint ID"
  value       = aws_vpc_endpoint.ssm.id
}

output "ec2messages_vpc_endpoint_id" {
  description = "EC2 Messages Endpoint ID"
  value       = aws_vpc_endpoint.ec2messages.id
}

output "ssmmessages_vpc_endpoint_id" {
  description = "SSM Messages Endpoint ID"
  value       = aws_vpc_endpoint.ssmmessages.id
}

output "kms_vpc_endpoint_id" {
  description = "KMS Interface Endpoint ID"
  value       = aws_vpc_endpoint.kms.id
}

output "secretsmanager_vpc_endpoint_id" {
  description = "Secrets Manager Endpoint ID"
  value       = aws_vpc_endpoint.secretsmanager.id
}
