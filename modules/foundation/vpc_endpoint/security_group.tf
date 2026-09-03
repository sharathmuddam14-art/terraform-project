resource "aws_security_group" "vpce" {
  count = var.create_endpoint_security_group ? 1 : 0

  name        = var.endpoint_security_group_name
  description = var.endpoint_security_group_description
  vpc_id      = var.vpc_id

  ingress {
    description = var.endpoint_security_group_ingress_description

    from_port = var.endpoint_security_group_ingress_from_port
    to_port   = var.endpoint_security_group_ingress_to_port
    protocol  = var.endpoint_security_group_ingress_protocol

    cidr_blocks = var.endpoint_security_group_ingress_cidr_blocks
  }

  egress {
    from_port = var.endpoint_security_group_egress_from_port
    to_port   = var.endpoint_security_group_egress_to_port
    protocol  = var.endpoint_security_group_egress_protocol

    cidr_blocks = var.endpoint_security_group_egress_cidr_blocks
  }

  tags = var.endpoint_security_group_tags
}
