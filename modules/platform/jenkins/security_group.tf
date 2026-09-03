resource "aws_security_group" "jenkins" {
  name        = "${var.name}-sg"
  description = "Security group for Jenkins"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Jenkins from platform ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}
