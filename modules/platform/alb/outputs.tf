output "alb_id" {
  description = "Platform ALB ID"
  value       = aws_lb.this.id
}

output "alb_dns_name" {
  description = "Platform ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_security_group_id" {
  description = "Platform ALB security group"
  value       = aws_security_group.alb.id
}


output "jenkins_instance_id" {
  value = local.enable_jenkins ? module.jenkins[0].instance_id : null
}

output "jenkins_private_ip" {
  value = local.enable_jenkins ? module.jenkins[0].private_ip : null
}

output "jenkins_url" {
  value = local.enable_jenkins ? "http://${aws_lb.this.dns_name}:${var.jenkins_port}" : null
}


output "nexus_instance_id" {
  value = local.enable_nexus ? module.nexus[0].instance_id : null
}

output "nexus_private_ip" {
  value = local.enable_nexus ? module.nexus[0].private_ip : null
}

output "nexus_url" {
  value = local.enable_nexus ? "http://${aws_lb.this.dns_name}:${var.nexus_port}" : null
}


output "sonarqube_instance_id" {
  value = local.enable_sonarqube ? module.sonarqube[0].instance_id : null
}

output "sonarqube_private_ip" {
  value = local.enable_sonarqube ? module.sonarqube[0].private_ip : null
}

output "sonarqube_url" {
  value = local.enable_sonarqube ? "http://${aws_lb.this.dns_name}:${var.sonarqube_port}" : null
}
