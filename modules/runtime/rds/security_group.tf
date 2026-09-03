############################################################
# RDS SECURITY GROUP
############################################################

resource "aws_security_group" "this" {

  name = var.security_group_name

  description = var.security_group_description

  vpc_id = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = var.security_group_name
    }
  )
}

############################################################
# DATABASE INGRESS
############################################################

resource "aws_vpc_security_group_ingress_rule" "database" {

  for_each = {
    for idx, sg_id in var.allowed_security_group_ids :
    tostring(idx) => sg_id
  }


  security_group_id = aws_security_group.this.id

  referenced_security_group_id = each.value

  from_port = var.port

  to_port = var.port

  ip_protocol = var.ingress_protocol
}

############################################################
# DATABASE EGRESS
############################################################

resource "aws_vpc_security_group_egress_rule" "all" {

  security_group_id = aws_security_group.this.id

  cidr_ipv4 = var.egress_cidr

  ip_protocol = var.egress_protocol
}
