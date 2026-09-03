resource "aws_security_group" "alb" {
  name        = "test-platform-alb-sg"
  description = "Security group for platform ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Jenkins dashboard"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  description = "Nexus dashboard"
  from_port   = 8081
  to_port     = 8081
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
ingress {
  description = "SonarQube dashboard"

  from_port = 9000
  to_port   = 9000

  protocol = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

  egress {
    description = "ALB outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-platform-alb-sg"
  }
}
