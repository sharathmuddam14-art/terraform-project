resource "aws_security_group" "nexus" {
  name        = "${var.name}-sg"
  description = "Security group for Nexus"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Nexus traffic from ALB"
    from_port       = 8081
    to_port         = 8081
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
