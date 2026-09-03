output "vpc_id" {

  value = module.vpc.vpc_id

}

output "public_subnet_ids" {

  value = module.vpc.public_subnet_ids

}

output "private_subnet_ids" {

  value = module.vpc.private_subnet_ids

}

output "internet_gateway_id" {

  value = module.vpc.internet_gateway_id

}

output "nat_gateway_ids" {

  value = module.vpc.nat_gateway_ids

}

output "nat_gateway_public_ips" {

  value = module.vpc.nat_gateway_public_ips

}
############################################################
# EKS OUTPUTS
############################################################


output "cluster_name" {

  description = "EKS cluster name"

  value = module.eks.cluster_name

}



output "cluster_endpoint" {

  description = "EKS API endpoint"

  value = module.eks.cluster_endpoint

}



output "cluster_version" {

  description = "Kubernetes version"

  value = module.eks.cluster_version

}



output "node_role_arn" {

  description = "Node IAM role ARN"

  value = module.eks.node_role_arn

}



output "node_security_group_id" {

  description = "Node security group"

  value = module.eks.node_security_group_id

}



############################################################
# IRSA OUTPUTS
############################################################


output "oidc_provider_arn" {

  description = "OIDC provider ARN"

  value = module.eks.oidc_provider_arn

}



output "ebs_csi_role_arn" {

  description = "EBS CSI IRSA role"

  value = module.eks.ebs_csi_role_arn

}


############################################################
# KMS OUTPUT
############################################################


output "kms_key_arn" {

  description = "KMS key ARN"

  value = module.kms.kms_key_arn

}
############################################################
# PLATFORM ALB
############################################################

output "platform_alb_dns_name" {
  description = "Platform ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = module.alb.jenkins_instance_id
}

output "jenkins_private_ip" {
  description = "Jenkins private IP"
  value       = module.alb.jenkins_private_ip
}

output "jenkins_url" {
  description = "Jenkins dashboard URL"
  value       = module.alb.jenkins_url
}
output "nexus_instance_id" {
  description = "Nexus EC2 instance ID"
  value       = module.alb.nexus_instance_id
}

output "nexus_private_ip" {
  description = "Nexus private IP"
  value       = module.alb.nexus_private_ip
}

output "nexus_url" {
  description = "Nexus dashboard URL"
  value       = module.alb.nexus_url
}
output "sonarqube_instance_id" {
  description = "SonarQube EC2 instance ID"
  value       = module.alb.sonarqube_instance_id
}

output "sonarqube_private_ip" {
  description = "SonarQube private IP address"
  value       = module.alb.sonarqube_private_ip
}

output "sonarqube_url" {
  description = "SonarQube dashboard URL"
  value       = module.alb.sonarqube_url
}

output "sonarqube_database_secret_arn" {
  description = "AWS Secrets Manager ARN containing SonarQube PostgreSQL credentials"
  value       = module.alb.sonarqube_database_secret_arn
}


