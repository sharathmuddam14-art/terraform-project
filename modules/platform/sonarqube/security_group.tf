resource "aws_security_group" "sonarqube" {
  name        = "${var.name}-sg"
  description = "Security group for SonarQube"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SonarQube from ALB"
    from_port       = var.sonarqube_port
    to_port         = var.sonarqube_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}
