resource "aws_security_group" "jenkins" {
  name        = "${var.name}-sg"
  description = "Security group for Jenkins"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Jenkins from ALB"
    from_port       = var.jenkins_port
    to_port         = var.jenkins_port
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
