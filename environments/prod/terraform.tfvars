project_name = "sharath-tfstate"

environment = "prod"

aws_region = "ap-southeast-1"

vpc_cidr = "10.20.0.0/16"

public_subnets = {

  public-1 = {

    cidr = "10.20.1.0/24"

    az = "ap-southeast-1a"

  }

  public-2 = {

    cidr = "10.20.2.0/24"

    az = "ap-southeast-1b"

  }

}

private_subnets = {

  private-1 = {

    cidr = "10.20.11.0/24"

    az = "ap-southeast-1a"

  }

  private-2 = {

    cidr = "10.20.12.0/24"

    az = "ap-southeast-1b"

  }
}

############################################################
# ECR CONFIGURATION
############################################################

registry_scan_type = "BASIC"

registry_scan_frequency = "SCAN_ON_PUSH"

repository_filter = {

  filter = "*"

  filter_type = "WILDCARD"

}

repositories = {

  frontend = {

    ########################################################
    # REPOSITORY
    ########################################################

    image_tag_mutability = "IMMUTABLE"

    ########################################################
    # SCANNING
    ########################################################

    scan_on_push = true

    ########################################################
    # ENCRYPTION
    ########################################################

    encryption = {

      type = "AES256"

      kms_key = null

    }

    ########################################################
    # LIFECYCLE
    ########################################################

    lifecycle = {

      enabled = true

      untagged = {

        priority = 1

        description = "Lifecycle rule for untagged images"

        tag_status = "untagged"

        count_type = "sinceImagePushed"

        count_unit = "days"

        count_number = 30

        action_type = "expire"

      }

      tagged = {

        priority = 2

        description = "Lifecycle rule for tagged images"

        tag_status = "tagged"

        tag_prefix_list = ["release"]

        count_type = "imageCountMoreThan"

        count_number = 10

        action_type = "expire"

      }

    }

    ########################################################
    # REPOSITORY POLICY
    ########################################################

    repository_policy = {

      enabled = false

      version = "2012-10-17"

      statement_id = "RepositoryAccess"

      effect = "Allow"

      principals = []

      actions = []

    }

  }

}
############################################################
# EKS CLUSTER
############################################################

cluster_name = "prod-eks"

cluster_version = "1.33"

cluster_endpoint_public_access = true

cluster_endpoint_private_access = true


############################################################
# EKS AUTHENTICATION
############################################################

authentication_mode = "API_AND_CONFIG_MAP"

bootstrap_cluster_creator_admin_permissions = true

############################################################
# CONTROL PLANE LOGGING
############################################################

log_retention_in_days = 30

############################################################
# LAUNCH TEMPLATE
############################################################

enable_launch_template = true

root_volume_size = 50

root_volume_type = "gp3"

root_volume_encrypted = true

delete_root_volume_on_termination = true

enable_detailed_monitoring = false

imds_http_endpoint = "enabled"

imds_http_tokens = "required"

imds_hop_limit = 2

imds_instance_metadata_tags = "disabled"

############################################################
# SECURITY GROUP
############################################################

cluster_security_group_description = "EKS cluster security group"

node_security_group_description = "EKS node security group"

node_to_cluster_port = 443

node_to_cluster_protocol = "tcp"

node_to_node_from_port = 0

node_to_node_to_port = 65535

node_to_node_protocol = "tcp"

node_egress_cidr_blocks = [
  "0.0.0.0/0"
]

cluster_egress_cidr_blocks = [
  "0.0.0.0/0"
]

############################################################
# EKS ACCESS ENTRY
############################################################

access_entry_type = "STANDARD"

access_policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAdminPolicy"

access_scope_type = "cluster"
############################################################
# CONTROL PLANE LOGS
############################################################

enabled_log_types = [
  "api",
  "audit",
  "authenticator"
]

############################################################
# EKS MANAGED NODE GROUPS
############################################################

node_groups = {

  default = {

    instance_types = ["t3.medium"]

    capacity_type = "ON_DEMAND"

    ami_type = "AL2023_x86_64_STANDARD"

    disk_size = 50

    desired_size = 2

    min_size = 2

    max_size = 5

    labels = {
      role = "general"
    }

    taints = []

  }

}

############################################################
# EKS ADDONS
############################################################

cluster_addons = {

  coredns = {}

  kube-proxy = {}

  vpc-cni = {}

  aws-ebs-csi-driver = {}

}

############################################################
# COMMON TAGS
############################################################

tags = {

  Environment = "prod"

  Project = "terraform"

  ManagedBy = "Terraform"

}
key_alias = "your-kms-alias"

deletion_window_in_days = 30
############################################################
# KARPENTER
############################################################

karpenter_namespace = "kube-system"

karpenter_chart_repository = "oci://public.ecr.aws/karpenter"

karpenter_chart_name = "karpenter"

karpenter_chart_version = "1.5.0"

controller_cpu_request = "100m"

controller_memory_request = "256Mi"

node_class_name = "default"

node_ami_family = "AL2023"

node_ami_alias = "al2023@latest"

node_pool_name = "default"

node_architecture = "amd64"

node_capacity_type = "on-demand"

interruption_queue_name = "microservices-eks-karpenter"
############################################################
# RDS CONFIGURATION
############################################################

rds = {

  identifier = "my-project-prod"

  engine         = "postgres"
  engine_version = "16"

  instance_class = "db.t3.small"

  allocated_storage     = 50
  max_allocated_storage = 200
  storage_type          = "gp3"

  storage_encrypted = true

  db_name  = "appdb"
  username = "dbowner"
  port     = 5432

  multi_az            = true
  publicly_accessible = false

  backup_retention_period = 30

  backup_window      = "03:00-04:00"
  maintenance_window = "sun:04:00-sun:05:00"

  copy_tags_to_snapshot    = true
  delete_automated_backups = true

  monitoring_interval                   = 60
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true

  deletion_protection = true
  skip_final_snapshot = false

  parameter_group_family = "postgres16"

  parameters = []

  security_group_name        = "my-project-prod-rds-sg"
  security_group_description = "Production RDS security group"

  ingress_protocol = "tcp"

  egress_cidr     = "0.0.0.0/0"
  egress_protocol = "-1"

  password_length      = 32
  password_special     = true
  password_min_lower   = 1
  password_min_upper   = 1
  password_min_numeric = 1
  password_min_special = 1

  secret_description = "RDS database credentials"
}
gateway_services = [
  "s3",
  "dynamodb"
]

gateway_endpoint_type = "Gateway"

interface_services = [
  "ssm",
  "ec2messages",
  "ssmmessages",
  "kms",
  "secretsmanager"
]

interface_endpoint_type = "Interface"

interface_private_dns_enabled = true

interface_security_group_ids = []

create_endpoint_security_group = true

endpoint_security_group_name = "sharath-tfstate-prod-vpce-sg"

endpoint_security_group_description = "Security Group for Interface VPC Endpoints"

endpoint_security_group_ingress_description = "Allow HTTPS from VPC"

endpoint_security_group_ingress_from_port = 443

endpoint_security_group_ingress_to_port = 443

endpoint_security_group_ingress_protocol = "tcp"

endpoint_security_group_ingress_cidr_blocks = [
  "10.20.0.0/16"
]

endpoint_security_group_egress_from_port = 0

endpoint_security_group_egress_to_port = 0

endpoint_security_group_egress_protocol = "-1"

endpoint_security_group_egress_cidr_blocks = [
  "0.0.0.0/0"
]

endpoint_tags = {
  Project     = "sharath-tfstate"
  Environment = "prod"
  ManagedBy   = "Terraform"
}

endpoint_security_group_tags = {
  Project     = "sharath-tfstate"
  Environment = "prod"
  ManagedBy   = "Terraform"
}
