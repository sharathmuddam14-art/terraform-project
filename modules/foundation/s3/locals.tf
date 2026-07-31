#################################################
# Local Values
#################################################

locals {

  #################################################
  # Bucket Name
  #################################################

  bucket_name = "${var.project_name}-${var.environment}-${var.bucket_name}"

  #################################################
  # Common Tags
  #################################################

  common_tags = merge(

    var.tags,

    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "S3"
    }

  )

}
