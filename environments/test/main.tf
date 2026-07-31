module "vpc" {

  source = "../../modules/foundation/vpc"

  project_name = var.project_name

  environment = var.environment

  aws_region = var.aws_region

  vpc_cidr = var.vpc_cidr

  public_subnets = var.public_subnets

  private_subnets = var.private_subnets

}
