output "instance_id" {
  description = "SonarQube EC2 instance ID"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "SonarQube private IP"
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "SonarQube security group ID"
  value       = aws_security_group.sonarqube.id
}

output "port" {
  description = "SonarQube port"
  value       = var.sonarqube_port
}
