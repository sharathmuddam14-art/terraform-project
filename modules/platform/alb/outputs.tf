output "alb_id" {
  description = "Platform ALB ID"
  value       = aws_lb.this.id
}

output "alb_dns_name" {
  description = "Platform ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  description = "Platform ALB security group ID"
  value       = aws_security_group.alb.id
}

output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = local.enable_jenkins ? module.jenkins[0].instance_id : null
}

output "jenkins_private_ip" {
  description = "Jenkins private IP"
  value       = local.enable_jenkins ? module.jenkins[0].private_ip : null
}

output "jenkins_url" {
  description = "Jenkins dashboard URL"
  value       = local.enable_jenkins ? "http://${aws_lb.this.dns_name}:8080" : null
}
output "nexus_instance_id" {
  description = "Nexus instance ID"
  value       = local.enable_nexus ? module.nexus[0].instance_id : null
}

output "nexus_private_ip" {
  description = "Nexus private IP"
  value       = local.enable_nexus ? module.nexus[0].private_ip : null
}

output "nexus_url" {
  description = "Nexus dashboard URL"
  value       = local.enable_nexus ? "http://${aws_lb.this.dns_name}:8081" : null
}
output "sonarqube_instance_id" {
  description = "SonarQube EC2 instance ID"

  value = local.enable_sonarqube ? module.sonarqube[0].instance_id : null
}

output "sonarqube_private_ip" {
  description = "SonarQube private IP"

  value = local.enable_sonarqube ? module.sonarqube[0].private_ip : null
}

output "sonarqube_url" {
  description = "SonarQube dashboard URL"

  value = local.enable_sonarqube ? "http://${aws_lb.this.dns_name}:9000" : null
}

output "sonarqube_database_secret_arn" {
  description = "SonarQube PostgreSQL credentials secret ARN"

  value = local.enable_sonarqube ? module.sonarqube[0].database_secret_arn : null
}
