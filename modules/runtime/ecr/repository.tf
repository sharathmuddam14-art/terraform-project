############################################################
# ECR Repository
############################################################

resource "aws_ecr_repository" "this" {

  for_each = var.repositories

  ##########################################################
  # Repository Name
  ##########################################################

  name = "${local.name_prefix}-${each.key}"

  ##########################################################
  # Image Tag Mutability
  ##########################################################

  image_tag_mutability = each.value.image_tag_mutability

  ##########################################################
  # Image Scanning
  ##########################################################

  image_scanning_configuration {

    scan_on_push = each.value.scan_on_push

  }

  ##########################################################
  # Encryption
  ##########################################################

  encryption_configuration {

    encryption_type = each.value.encryption.type

    kms_key = each.value.encryption.type == "KMS" ? each.value.encryption.kms_key : null

  }

  ##########################################################
  # Tags
  ##########################################################

  tags = local.common_tags

}
