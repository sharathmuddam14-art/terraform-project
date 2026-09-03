locals {
  gateway_service_names = {
    for service in var.gateway_services :
    service => "com.amazonaws.${data.aws_region.current.name}.${service}"
  }
}

resource "aws_vpc_endpoint" "gateway" {
  for_each = var.gateway_services

  vpc_id = var.vpc_id

  service_name = local.gateway_service_names[each.value]

  vpc_endpoint_type = var.gateway_endpoint_type

  route_table_ids = var.gateway_route_table_ids

  tags = merge(
    var.endpoint_tags,
    {
      Service = each.value
    }
  )
}
