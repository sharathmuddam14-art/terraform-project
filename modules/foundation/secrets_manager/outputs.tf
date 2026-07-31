#################################################
# Secret ID
#################################################

output "secret_id" {

  description = "Secrets Manager Secret ID"

  value = aws_secretsmanager_secret.this.id

}

#################################################
# Secret ARN
#################################################

output "secret_arn" {

  description = "Secrets Manager Secret ARN"

  value = aws_secretsmanager_secret.this.arn

}

#################################################
# Secret Name
#################################################

output "secret_name" {

  description = "Secrets Manager Secret Name"

  value = aws_secretsmanager_secret.this.name

}

#################################################
# Secret Version ID
#################################################

output "secret_version_id" {

  description = "Secret Version ID"

  value = aws_secretsmanager_secret_version.this.version_id

}

#################################################
# Secret KMS Key
#################################################

output "kms_key_id" {

  description = "KMS Key used for Secret Encryption"

  value = aws_secretsmanager_secret.this.kms_key_id

}

#################################################
# Secret ARN (Friendly Output)
#################################################

output "secret_value_arn" {

  description = "Secret ARN"

  value = aws_secretsmanager_secret.this.arn

}

#################################################
# Summary
#################################################

output "secret_summary" {

  description = "Secrets Manager Summary"

  value = {

    secret_name       = aws_secretsmanager_secret.this.name

    secret_arn        = aws_secretsmanager_secret.this.arn

    kms_key           = aws_secretsmanager_secret.this.kms_key_id

    recovery_window   = aws_secretsmanager_secret.this.recovery_window_in_days

  }

}
