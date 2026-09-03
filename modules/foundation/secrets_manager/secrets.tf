#################################################
# AWS Secrets Manager Secret
#################################################

resource "aws_secretsmanager_secret" "this" {

  name = local.secret_name

  description = var.secret_description

  kms_key_id = var.kms_key_id

  recovery_window_in_days = 7

  tags = local.common_tags

}

#################################################
# Secret Version
#################################################

resource "aws_secretsmanager_secret_version" "this" {

  secret_id = aws_secretsmanager_secret.this.id

  secret_string = var.secret_value

}
