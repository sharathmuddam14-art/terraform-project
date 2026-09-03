resource "aws_lb_target_group" "jenkins" {
  count = local.enable_jenkins ? 1 : 0

  name = "test-jenkins-tg"

  port     = 8080
  protocol = "HTTP"

  vpc_id = var.vpc_id

  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "8080"
    path                = "/login"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "jenkins" {
  count = local.enable_jenkins ? 1 : 0

  target_group_arn = aws_lb_target_group.jenkins[0].arn

  target_id = module.jenkins[0].instance_id

  port = 8080
}
resource "aws_lb_target_group" "nexus" {
  count = local.enable_nexus ? 1 : 0

  name = "test-nexus-tg"

  port     = 8081
  protocol = "HTTP"

  vpc_id = var.vpc_id

  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "8081"
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "nexus" {
  count = local.enable_nexus ? 1 : 0

  target_group_arn = aws_lb_target_group.nexus[0].arn

  target_id = module.nexus[0].instance_id

  port = 8081
}
resource "aws_lb_target_group" "sonarqube" {
  count = local.enable_sonarqube ? 1 : 0

  name = "test-sonarqube-tg"

  port     = 9000
  protocol = "HTTP"

  vpc_id = var.vpc_id

  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "9000"
    path                = "/api/system/status"
    matcher             = "200-399"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "sonarqube" {
  count = local.enable_sonarqube ? 1 : 0

  target_group_arn = aws_lb_target_group.sonarqube[0].arn

  target_id = module.sonarqube[0].instance_id

  port = 9000
}
