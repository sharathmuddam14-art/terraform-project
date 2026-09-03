resource "aws_secretsmanager_secret" "sonarqube_db" {
  name = "${var.name}/database"

  description = "PostgreSQL credentials for SonarQube"

  tags = {
    Name    = "${var.name}-database-secret"
    Service = "sonarqube"
  }
}
