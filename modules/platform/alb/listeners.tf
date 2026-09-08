resource "aws_lb_listener" "jenkins" {
  count = local.enable_jenkins ? 1 : 0

  load_balancer_arn = aws_lb.this.arn

  port     = var.jenkins_port
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.jenkins[0].arn
  }
}


resource "aws_lb_listener" "nexus" {
  count = local.enable_nexus ? 1 : 0

  load_balancer_arn = aws_lb.this.arn

  port     = var.nexus_port
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.nexus[0].arn
  }
}


resource "aws_lb_listener" "sonarqube" {
  count = local.enable_sonarqube ? 1 : 0

  load_balancer_arn = aws_lb.this.arn

  port     = var.sonarqube_port
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.sonarqube[0].arn
  }
}
