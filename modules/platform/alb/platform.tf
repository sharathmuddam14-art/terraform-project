module "jenkins" {
  count = local.enable_jenkins ? 1 : 0

  source = "../jenkins"

  name = "${var.environment}-jenkins"

  vpc_id = var.vpc_id

  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  instance_type    = var.jenkins_instance_type
  root_volume_size = var.jenkins_root_volume_size

  java_version    = var.jenkins_java_version
  jenkins_package = var.jenkins_package
  jenkins_port    = var.jenkins_port
}


module "nexus" {
  count = local.enable_nexus ? 1 : 0

  source = "../nexus"

  name = "${var.environment}-nexus"

  vpc_id = var.vpc_id

  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  instance_type    = var.nexus_instance_type
  root_volume_size = var.nexus_root_volume_size

  java_version  = var.nexus_java_version
  nexus_version = var.nexus_version
  nexus_port    = var.nexus_port
}


module "sonarqube" {
  count = local.enable_sonarqube ? 1 : 0

  source = "../sonarqube"

  name = "${var.environment}-sonarqube"

  vpc_id = var.vpc_id

  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  instance_type    = var.sonarqube_instance_type
  root_volume_size = var.sonarqube_root_volume_size

  java_version      = var.sonarqube_java_version
  sonarqube_version = var.sonarqube_version
  sonarqube_port    = var.sonarqube_port

  db_name = var.sonarqube_db_name
  db_user = var.sonarqube_db_user
}
