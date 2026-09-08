resource "aws_lb_target_group" "jenkins" {
  count = local.enable_jenkins ? 1 : 0

  name = "${var.environment}-jenkins-tg"

  port     = var.jenkins_port
  protocol = "HTTP"

  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/login"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.environment}-jenkins-tg"
    Environment = var.environment
  }
}


resource "aws_lb_target_group_attachment" "jenkins" {
  count = local.enable_jenkins ? 1 : 0

  target_group_arn = aws_lb_target_group.jenkins[0].arn

  target_id = module.jenkins[0].instance_id

  port = var.jenkins_port
}


resource "aws_lb_target_group" "nexus" {
  count = local.enable_nexus ? 1 : 0

  name = "${var.environment}-nexus-tg"

  port     = var.nexus_port
  protocol = "HTTP"

  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.environment}-nexus-tg"
    Environment = var.environment
  }
}


resource "aws_lb_target_group_attachment" "nexus" {
  count = local.enable_nexus ? 1 : 0

  target_group_arn = aws_lb_target_group.nexus[0].arn

  target_id = module.nexus[0].instance_id

  port = var.nexus_port
}


resource "aws_lb_target_group" "sonarqube" {
  count = local.enable_sonarqube ? 1 : 0

  name = "${var.environment}-sonarqube-tg"

  port     = var.sonarqube_port
  protocol = "HTTP"

  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/api/system/status"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "${var.environment}-sonarqube-tg"
    Environment = var.environment
  }
}


resource "aws_lb_target_group_attachment" "sonarqube" {
  count = local.enable_sonarqube ? 1 : 0

  target_group_arn = aws_lb_target_group.sonarqube[0].arn

  target_id = module.sonarqube[0].instance_id

  port = var.sonarqube_port
}
