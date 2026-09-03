############################################################
# RDS INSTANCE
############################################################

resource "aws_db_instance" "this" {

  ##########################################################
  # IDENTIFICATION
  ##########################################################

  identifier = var.identifier

  ##########################################################
  # DATABASE
  ##########################################################

  engine         = var.engine
  engine_version = var.engine_version

  db_name  = var.db_name
  username = var.username
  password = var.password

  port = var.port

  ##########################################################
  # INSTANCE
  ##########################################################

  instance_class = var.instance_class

  ##########################################################
  # STORAGE
  ##########################################################

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type

  storage_encrypted = local.encryption.enabled
  kms_key_id        = local.encryption.kms_key_id

  ##########################################################
  # NETWORK
  ##########################################################

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  publicly_accessible = var.publicly_accessible
  multi_az            = var.multi_az

  ##########################################################
  # PARAMETER GROUP
  ##########################################################

  parameter_group_name = aws_db_parameter_group.this.name

  ##########################################################
  # MONITORING
  ##########################################################

  monitoring_interval = var.monitoring_interval

  monitoring_role_arn = (
    var.create_monitoring_role
    ? aws_iam_role.monitoring[0].arn
    : null
  )

  performance_insights_enabled = var.performance_insights_enabled

  performance_insights_retention_period = (
    var.performance_insights_enabled
    ? var.performance_insights_retention_period
    : null
  )

  ##########################################################
  # BACKUP
  ##########################################################

  backup_retention_period = local.backup.retention_period
  backup_window           = local.backup.backup_window
  maintenance_window      = local.backup.maintenance_window

  deletion_protection = local.backup.deletion_protection
  skip_final_snapshot = local.backup.skip_final_snapshot

  copy_tags_to_snapshot    = local.backup.copy_tags_to_snapshot
  delete_automated_backups = local.backup.delete_automated_backups

  ##########################################################
  # TAGS
  ##########################################################

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-rds"
    }
  )
}
