############################################################
# RDS MASTER PASSWORD
############################################################

resource "random_password" "rds" {

  length = var.rds.password_length

  special = var.rds.password_special

  min_lower = var.rds.password_min_lower

  min_upper = var.rds.password_min_upper

  min_numeric = var.rds.password_min_numeric

  min_special = var.rds.password_min_special
}
