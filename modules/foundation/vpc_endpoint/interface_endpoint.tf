locals {
  interface_service_names = {
    for service in var.interface_services :
    service => "com.amazonaws.${data.aws_region.current.name}.${service}"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = var.interface_services

  vpc_id = var.vpc_id

  service_name = local.interface_service_names[each.value]

  vpc_endpoint_type = var.interface_endpoint_type

  subnet_ids = var.interface_subnet_ids

  security_group_ids = concat(
    tolist(var.interface_security_group_ids),
    var.create_endpoint_security_group ? [aws_security_group.vpce[0].id] : []
  )

  private_dns_enabled = var.interface_private_dns_enabled

  tags = merge(
    var.endpoint_tags,
    {
      Service = each.value
    }
  )
}
