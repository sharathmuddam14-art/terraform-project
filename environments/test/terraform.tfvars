project_name = "sharath-tfstate"

environment = "test"

aws_region = "ap-southeast-1"

vpc_cidr = "10.10.0.0/16"

public_subnets = {

  public-1 = {

    cidr = "10.10.1.0/24"

    az = "ap-southeast-1a"

  }
  public_2 = {
    cidr = "10.10.2.0/24"
    az   = "ap-southeast-1b"
  }

}

private_subnets = {

  private-1 = {

    cidr = "10.10.11.0/24"

    az = "ap-southeast-1a"

  }
  private-2 = {

    cidr = "10.10.12.0/24"

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

        tag_prefix_list = ["v"]

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
# Common Tags
############################################################

tags = {

  Project = "my-project"

  Environment = "test"

  ManagedBy = "Terraform"


}
############################################################
# EKS CLUSTER CONFIGURATION
############################################################

cluster_name = "test-eks"


cluster_version = "1.33"


cluster_endpoint_public_access = true


cluster_endpoint_private_access = true



############################################################
# EKS NODE GROUP CONFIGURATION
############################################################

node_groups = {


  default = {


    instance_types = [

      "c7i-flex.large"

    ]


    capacity_type = "ON_DEMAND"


    ami_type = "AL2023_x86_64_STANDARD"


    disk_size = 50


    desired_size = 1


    min_size = 1


    max_size = 1



    labels = {


      Environment = "test"

    }


  }

}



############################################################
# EKS ADDONS
############################################################

cluster_addons = {


  coredns = {


    version = "v1.12.4-eksbuild.18"


    resolve_conflicts_on_create = "OVERWRITE"


    resolve_conflicts_on_update = "OVERWRITE"

  }



  aws-ebs-csi-driver = {


    version = "v1.63.0-eksbuild.1"


    resolve_conflicts_on_create = "OVERWRITE"


    resolve_conflicts_on_update = "OVERWRITE"
    service_account_role_arn    = "arn:aws:iam::010160406667:role/test-eks-ebs-csi-role"

  }



  kube-proxy = {


    version = "v1.33.0-eksbuild.2"

  }
}

# EKS LAUNCH TEMPLATE
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

imds_instance_metadata_tags = "enabled"
rds = {

  ##########################################################
  # DATABASE
  ##########################################################

  identifier     = "sharath-tfstate-test-mysql"
  engine         = "mysql"
  engine_version = "8.0"

  db_name            = "tenantcrm"
  username           = "dbowner"
  port               = 3306
  secret_description = "Credentials for test MySQL RDS"

  ##########################################################
  # INSTANCE
  ##########################################################

  instance_class = "db.t3.micro"


  ##########################################################
  # STORAGE
  ##########################################################

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true


  ##########################################################
  # NETWORK ACCESS
  ##########################################################

  multi_az            = false
  publicly_accessible = false


  ##########################################################
  # BACKUP
  ##########################################################

  backup_retention_period  = 1
  backup_window            = "03:00-04:00"
  maintenance_window       = "sun:04:00-sun:05:00"
  copy_tags_to_snapshot    = true
  delete_automated_backups = true


  ##########################################################
  # DELETION
  ##########################################################

  deletion_protection = false
  skip_final_snapshot = true


  ##########################################################
  # MONITORING
  ##########################################################

  monitoring_interval                   = 60
  performance_insights_enabled          = false
  performance_insights_retention_period = 7
  create_monitoring_role                = true


  ##########################################################
  # PARAMETER GROUP
  ##########################################################

  parameter_group_family = "mysql8.0"

  parameters = []


  ##########################################################
  # SECURITY GROUP
  ##########################################################

  security_group_name        = "sharath-tfstate-test-mysql-sg"
  security_group_description = "Security group for test MySQL RDS"

  ingress_protocol = "tcp"

  egress_cidr     = "0.0.0.0/0"
  egress_protocol = "-1"


  ##########################################################
  # PASSWORD
  ##########################################################

  password_length      = 16
  password_special     = true
  password_min_lower   = 1
  password_min_upper   = 1
  password_min_numeric = 1
  password_min_special = 1

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

endpoint_security_group_name = "sharath-tfstate-test-vpce-sg"

endpoint_security_group_description = "Security Group for Interface VPC Endpoints"

endpoint_security_group_ingress_description = "Allow HTTPS from VPC"

endpoint_security_group_ingress_from_port = 443

endpoint_security_group_ingress_to_port = 443

endpoint_security_group_ingress_protocol = "tcp"

endpoint_security_group_ingress_cidr_blocks = [
  "10.10.0.0/16"
]

endpoint_security_group_egress_from_port = 0

endpoint_security_group_egress_to_port = 0

endpoint_security_group_egress_protocol = "-1"

endpoint_security_group_egress_cidr_blocks = [
  "0.0.0.0/0"
]

endpoint_tags = {
  Project     = "sharath-tfstate"
  Environment = "test"
  ManagedBy   = "Terraform"
}

endpoint_security_group_tags = {
  Project     = "sharath-tfstate"
  Environment = "test"
  ManagedBy   = "Terraform"
}
authentication_mode                         = "API_AND_CONFIG_MAP"
bootstrap_cluster_creator_admin_permissions = true
enabled_log_types                           = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
log_retention_in_days                       = 30
############################################################
# EKS SECURITY GROUP CONFIGURATION
############################################################

cluster_security_group_description = "Security group for EKS control plane"
node_security_group_description    = "Security group for EKS worker nodes"

node_to_cluster_port     = 443
node_to_cluster_protocol = "tcp"

node_to_node_from_port = 0
node_to_node_to_port   = 65535
node_to_node_protocol  = "tcp"

node_egress_cidr_blocks    = ["0.0.0.0/0"]
cluster_egress_cidr_blocks = ["0.0.0.0/0"]

############################################################
# EKS ACCESS CONFIGURATION
############################################################

access_entry_type = "STANDARD"

access_policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

access_scope_type = "cluster"
############################################################
# AWS LOAD BALANCER CONTROLLER
############################################################

load_balancer_controller_chart_version = "1.14.0"

load_balancer_controller_replicas = 2
# ============================================================
# PLATFORM
# ============================================================
platform_alb_name = "test-platform-alb"


# ============================================================
# SERVICES
# ============================================================

jenkins_enabled   = true
nexus_enabled     = true
sonarqube_enabled = false


# ============================================================
# JAVA
# ============================================================

jenkins_java_version   = "21"
nexus_java_version     = "21"
sonarqube_java_version = "21"


# ============================================================
# APPLICATION PORTS
# ============================================================

jenkins_port   = 8080
nexus_port     = 8081
sonarqube_port = 9000


# ============================================================
# EC2 INSTANCE TYPES
# ============================================================

jenkins_instance_type   = "t3.micro"
nexus_instance_type     = "c7i-flex.large"
sonarqube_instance_type = "t3.micro"

jenkins_ami_id = "ami-02159ad7e38d562f2"
nexus_ami_id   = "ami-086e059ace28f3ad5"


# ============================================================
# ROOT VOLUME
# ============================================================

jenkins_root_volume_size   = 30
nexus_root_volume_size     = 50
sonarqube_root_volume_size = 50


# ============================================================
# SOFTWARE
# ============================================================

jenkins_package   = "jenkins"
nexus_version     = "3.95.3-02"
sonarqube_version = "26.8.0.126808"


# ============================================================
# SONARQUBE DATABASE
# ============================================================

sonarqube_db_name = "sonarqube"
sonarqube_db_user = "sonarqube"
