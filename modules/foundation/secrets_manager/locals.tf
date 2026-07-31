locals {

  secret_name = "${var.project_name}/${var.environment}/${var.secret_name}"

  common_tags = merge(

    var.tags,

    {

      Project = var.project_name

      Environment = var.environment

      ManagedBy = "Terraform"

      Module = "SecretsManager"

    }

  )

}
