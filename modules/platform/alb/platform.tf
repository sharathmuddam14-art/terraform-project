module "jenkins" {
  count = local.enable_jenkins ? 1 : 0

  source = "../jenkins"

  name = "test-jenkins"

  vpc_id = var.vpc_id

  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  instance_type    = "t3.medium"
  root_volume_size = 30
}

module "nexus" {
  count = local.enable_nexus ? 1 : 0

  source = "../nexus"

  name = "test-nexus"

  vpc_id = var.vpc_id

  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  instance_type    = "t3.medium"
  root_volume_size = 50
}
module "sonarqube" {
  count = local.enable_sonarqube ? 1 : 0

  source = "../sonarqube"

  name = "test-sonarqube"

  aws_region = "ap-southeast-1"

  vpc_id = var.vpc_id

  private_subnet_ids = var.private_subnet_ids

  alb_security_group_id = aws_security_group.alb.id

  instance_type    = "t2.medium"
  root_volume_size = 50
}
