############################################################
# RDS ENHANCED MONITORING IAM ROLE
############################################################

resource "aws_iam_role" "monitoring" {

  count = var.create_monitoring_role ? 1 : 0

  name = "${local.name_prefix}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds-monitoring-role"
    }
  )
}

############################################################
# AWS MANAGED MONITORING POLICY
############################################################

resource "aws_iam_role_policy_attachment" "monitoring" {

  count = var.create_monitoring_role ? 1 : 0

  role = aws_iam_role.monitoring[0].name

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
