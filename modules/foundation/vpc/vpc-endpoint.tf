###############################################################
# Security Group for Interface VPC Endpoints
###############################################################

resource "aws_security_group" "vpce_sg" {

  name        = "${local.name_prefix}-vpce-sg"
  description = "Security Group for Interface VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS from VPC"

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-vpce-sg"
    }
  )
}

###############################################################
# Amazon S3 Gateway Endpoint
###############################################################

resource "aws_vpc_endpoint" "s3" {

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(
    [aws_route_table.public.id],
    values(aws_route_table.private)[*].id
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-s3-endpoint"
    }
  )
}

###############################################################
# Amazon DynamoDB Gateway Endpoint
###############################################################

resource "aws_vpc_endpoint" "dynamodb" {

  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(
    [aws_route_table.public.id],
    values(aws_route_table.private)[*].id
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-dynamodb-endpoint"
    }
  )
}

###############################################################
# AWS Systems Manager (SSM)
###############################################################

resource "aws_vpc_endpoint" "ssm" {

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.private)[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]
  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ssm-endpoint"
    }
  )
}

###############################################################
# EC2 Messages Endpoint
###############################################################

resource "aws_vpc_endpoint" "ec2messages" {

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.private)[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]
  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2messages-endpoint"
    }
  )
}

###############################################################
# SSM Messages Endpoint
###############################################################

resource "aws_vpc_endpoint" "ssmmessages" {

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.private)[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]
  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ssmmessages-endpoint"
    }
  )
}

###############################################################
# AWS KMS Endpoint
###############################################################

resource "aws_vpc_endpoint" "kms" {

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.kms"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.private)[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]
  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-kms-endpoint"
    }
  )
}

###############################################################
# AWS Secrets Manager Endpoint
###############################################################

resource "aws_vpc_endpoint" "secretsmanager" {

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = values(aws_subnet.private)[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]
  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-secretsmanager-endpoint"
    }
  )
}
