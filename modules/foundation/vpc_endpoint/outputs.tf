output "gateway_endpoint_ids" {
  description = "Gateway endpoint IDs"

  value = {
    for service, endpoint in aws_vpc_endpoint.gateway :
    service => endpoint.id
  }
}

output "interface_endpoint_ids" {
  description = "Interface endpoint IDs"

  value = {
    for service, endpoint in aws_vpc_endpoint.interface :
    service => endpoint.id
  }
}

output "endpoint_security_group_id" {
  description = "Interface endpoint security group ID"

  value = try(aws_security_group.vpce[0].id, null)
}
