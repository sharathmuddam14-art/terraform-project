module "vpc" {

  source = "../../modules/foundation/vpc"

  project_name = var.project_name

  environment = var.environment

  aws_region = var.aws_region

  vpc_cidr = var.vpc_cidr

  public_subnets = var.public_subnets

  private_subnets = var.private_subnets

}
############################################################
# KMS MODULE
############################################################

module "kms" {

  source = "../../modules/foundation/kms"

  project_name = var.project_name

  environment = var.environment

  aws_region = var.aws_region

  key_alias = var.key_alias

  deletion_window_in_days = var.deletion_window_in_days

}
############################################################
# ECR Module
############################################################

module "ecr" {

  source = "../../modules/runtime/ecr"

  ##########################################################
  # Project Information
  ##########################################################

  project_name = var.project_name
  environment  = var.environment

  ##########################################################
  # Common Tags
  ##########################################################

  tags = var.tags

  ##########################################################
  # Registry Scanning Configuration
  ##########################################################

  registry_scan_type      = var.registry_scan_type
  registry_scan_frequency = var.registry_scan_frequency
  repository_filter       = var.repository_filter

  ##########################################################
  # Repository Configuration
  ##########################################################

  repositories = var.repositories

}
############################################################
# EKS MODULE
############################################################

module "eks" {

  source = "../../modules/runtime/eks"

  ##########################################################
  # CLUSTER
  ##########################################################

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  ##########################################################
  # NETWORKING
  ##########################################################

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  ##########################################################
  # API ACCESS
  ##########################################################

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  ##########################################################
  # AUTHENTICATION
  ##########################################################

  authentication_mode = var.authentication_mode

  bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions

  ##########################################################
  # CONTROL PLANE LOGGING
  ##########################################################

  enabled_log_types     = var.enabled_log_types
  log_retention_in_days = var.log_retention_in_days

  ##########################################################
  # KMS
  ##########################################################

  kms_key_arn = module.kms.kms_key_arn

  ##########################################################
  # NODE GROUPS
  ##########################################################

  node_groups = var.node_groups

  ##########################################################
  # LAUNCH TEMPLATE
  ##########################################################

  enable_launch_template            = var.enable_launch_template
  root_volume_size                  = var.root_volume_size
  root_volume_type                  = var.root_volume_type
  root_volume_encrypted             = var.root_volume_encrypted
  delete_root_volume_on_termination = var.delete_root_volume_on_termination
  enable_detailed_monitoring        = var.enable_detailed_monitoring

  imds_http_endpoint          = var.imds_http_endpoint
  imds_http_tokens            = var.imds_http_tokens
  imds_hop_limit              = var.imds_hop_limit
  imds_instance_metadata_tags = var.imds_instance_metadata_tags

  ##########################################################
  # SECURITY GROUPS
  ##########################################################

  cluster_security_group_description = var.cluster_security_group_description
  node_security_group_description    = var.node_security_group_description

  node_to_cluster_port     = var.node_to_cluster_port
  node_to_cluster_protocol = var.node_to_cluster_protocol

  node_to_node_from_port = var.node_to_node_from_port
  node_to_node_to_port   = var.node_to_node_to_port
  node_to_node_protocol  = var.node_to_node_protocol

  node_egress_cidr_blocks    = var.node_egress_cidr_blocks
  cluster_egress_cidr_blocks = var.cluster_egress_cidr_blocks

  ##########################################################
  # ACCESS ENTRY
  ##########################################################

  access_entry_type = var.access_entry_type
  access_policy_arn = var.access_policy_arn
  access_scope_type = var.access_scope_type

  ##########################################################
  # ADDONS
  ##########################################################

  cluster_addons = var.cluster_addons

  ##########################################################
  # TAGS
  ##########################################################

  tags = var.tags
}
############################################################
# KARPENTER
############################################################

module "karpenter" {

  source = "../../modules/runtime/eks/karpenter"




  ##########################################################
  # EKS
  ##########################################################

  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data

  ##########################################################
  # OIDC
  ##########################################################

  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url   = module.eks.oidc_issuer_url

  ##########################################################
  # NETWORK
  ##########################################################

  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  node_security_group_id = module.eks.node_security_group_id

  ##########################################################
  # NODE ROLE
  ##########################################################

  node_role_arn = module.eks.node_role_arn


  ##########################################################
  # KARPENTER HELM
  ##########################################################

  karpenter_namespace        = var.karpenter_namespace
  karpenter_chart_repository = var.karpenter_chart_repository
  karpenter_chart_name       = var.karpenter_chart_name
  karpenter_chart_version    = var.karpenter_chart_version

  controller_cpu_request    = var.controller_cpu_request
  controller_memory_request = var.controller_memory_request

  ##########################################################
  # NODE CLASS
  ##########################################################

  node_class_name = var.node_class_name
  node_ami_family = var.node_ami_family
  node_ami_alias  = var.node_ami_alias

  ##########################################################
  # NODE POOL
  ##########################################################

  node_pool_name     = var.node_pool_name
  node_architecture  = var.node_architecture
  node_capacity_type = var.node_capacity_type

  ##########################################################
  # INTERRUPTION QUEUE
  ##########################################################

  interruption_queue_name = var.interruption_queue_name
  ##########################################################
  # TAGS
  ##########################################################

  tags = var.tags
}
############################################################
# RDS MODULE
############################################################

module "rds" {

  source = "../../modules/runtime/rds"

  ##########################################################
  # PROJECT
  ##########################################################

  project_name = var.project_name
  environment  = var.environment

  ##########################################################
  # NETWORK
  ##########################################################

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids

  ##########################################################
  # DATABASE
  ##########################################################

  identifier     = var.rds.identifier
  engine         = var.rds.engine
  engine_version = var.rds.engine_version

  db_name  = var.rds.db_name
  username = var.rds.username
  password = random_password.rds.result

  port = var.rds.port

  ##########################################################
  # INSTANCE
  ##########################################################

  instance_class = var.rds.instance_class

  ##########################################################
  # STORAGE
  ##########################################################

  allocated_storage     = var.rds.allocated_storage
  max_allocated_storage = var.rds.max_allocated_storage
  storage_type          = var.rds.storage_type

  storage_encrypted = var.rds.storage_encrypted
  kms_key_arn       = module.kms.kms_key_arn

  ##########################################################
  # NETWORK ACCESS
  ##########################################################

  publicly_accessible = var.rds.publicly_accessible
  multi_az            = var.rds.multi_az

  ##########################################################
  # SECURITY GROUP
  ##########################################################

  security_group_name        = var.rds.security_group_name
  security_group_description = var.rds.security_group_description

  allowed_security_group_ids = [
    module.eks.node_security_group_id
  ]

  ingress_protocol = var.rds.ingress_protocol

  egress_cidr     = var.rds.egress_cidr
  egress_protocol = var.rds.egress_protocol

  ##########################################################
  # BACKUP
  ##########################################################

  backup_retention_period = var.rds.backup_retention_period
  backup_window           = var.rds.backup_window
  maintenance_window      = var.rds.maintenance_window

  copy_tags_to_snapshot    = var.rds.copy_tags_to_snapshot
  delete_automated_backups = var.rds.delete_automated_backups

  ##########################################################
  # DELETION
  ##########################################################

  deletion_protection = var.rds.deletion_protection
  skip_final_snapshot = var.rds.skip_final_snapshot

  ##########################################################
  # MONITORING
  ##########################################################

  monitoring_interval = var.rds.monitoring_interval

  performance_insights_enabled = (
    var.rds.performance_insights_enabled
  )

  performance_insights_retention_period = (
    var.rds.performance_insights_retention_period
  )

  create_monitoring_role = var.rds.create_monitoring_role

  ##########################################################
  # PARAMETER GROUP
  ##########################################################

  parameter_group_family = var.rds.parameter_group_family
  parameters             = var.rds.parameters

  ##########################################################
  # TAGS
  ##########################################################

  tags = var.tags
}
############################################################
# SECRETS MANAGER
############################################################

module "rds_secret" {

  source = "../../modules/foundation/secrets_manager"


  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  secret_name        = local.rds_secret_name
  secret_description = var.rds.secret_description

  kms_key_id = module.kms.kms_key_arn

  secret_value = random_password.rds.result

  tags = var.tags
}
module "vpc_endpoint" {
  source = "../../modules/foundation/vpc_endpoint"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id


  gateway_services      = var.gateway_services
  gateway_endpoint_type = var.gateway_endpoint_type

  gateway_route_table_ids = toset(
    concat(
      [module.vpc.public_route_table_id],
      module.vpc.private_route_table_ids
    )
  )

  interface_services      = var.interface_services
  interface_endpoint_type = var.interface_endpoint_type

  interface_subnet_ids = toset(
    module.vpc.private_subnet_ids
  )

  interface_security_group_ids = var.interface_security_group_ids

  interface_private_dns_enabled = var.interface_private_dns_enabled

  create_endpoint_security_group = var.create_endpoint_security_group

  endpoint_security_group_name = var.endpoint_security_group_name

  endpoint_security_group_description = var.endpoint_security_group_description

  endpoint_security_group_ingress_description = var.endpoint_security_group_ingress_description

  endpoint_security_group_ingress_from_port = var.endpoint_security_group_ingress_from_port

  endpoint_security_group_ingress_to_port = var.endpoint_security_group_ingress_to_port

  endpoint_security_group_ingress_protocol = var.endpoint_security_group_ingress_protocol

  endpoint_security_group_ingress_cidr_blocks = var.endpoint_security_group_ingress_cidr_blocks

  endpoint_security_group_egress_from_port = var.endpoint_security_group_egress_from_port

  endpoint_security_group_egress_to_port = var.endpoint_security_group_egress_to_port

  endpoint_security_group_egress_protocol = var.endpoint_security_group_egress_protocol

  endpoint_security_group_egress_cidr_blocks = var.endpoint_security_group_egress_cidr_blocks

  endpoint_tags = var.endpoint_tags

  endpoint_security_group_tags = var.endpoint_security_group_tags
}
