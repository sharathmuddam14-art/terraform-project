locals {


  name = "${var.project_name}-${var.environment}"



  tags = merge(

    var.tags,

    {

      Environment = var.environment

      ManagedBy = "Terraform"

    }

  )
}
locals {
  rds_secret_name = "${var.project_name}-${var.environment}-rds"
}
