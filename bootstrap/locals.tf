locals {

  bucket_name = "${var.project_name}-${data.aws_caller_identity.current.account_id}"

  common_tags = {

    Project     = var.project_name

    Environment = "bootstrap"

    ManagedBy   = "Terraform"

  }

}
