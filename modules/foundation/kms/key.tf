resource "aws_kms_key" "this" {

  description = "${local.name_prefix} KMS Key"

  deletion_window_in_days = var.deletion_window_in_days

  enable_key_rotation = var.enable_key_rotation

  policy = data.aws_iam_policy_document.kms_policy.json

  tags = merge(

    local.common_tags,

    {

      Name = "${local.name_prefix}-kms"

    }

  )

}
