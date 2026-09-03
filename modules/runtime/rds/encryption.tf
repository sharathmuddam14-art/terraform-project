############################################################
# RDS ENCRYPTION
############################################################

locals {

  encryption = {

    enabled = var.storage_encrypted

    kms_key_id = var.storage_encrypted ? var.kms_key_arn : null

  }

}

