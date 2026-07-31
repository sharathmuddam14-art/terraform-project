output "bucket_name" {

  value = aws_s3_bucket.state_bucket.id

}

output "kms_key_arn" {

  value = aws_kms_key.state_key.arn

}

output "dynamodb_table" {

  value = aws_dynamodb_table.lock_table.name

}
