resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = var.alb_name
    Environment = var.environment
    Service     = "platform-alb"
  }
}
