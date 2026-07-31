#################################################
# S3 Server-Side Encryption (SSE-KMS)
#################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  bucket = aws_s3_bucket.this.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "aws:kms"

      kms_master_key_id = var.kms_key_arn

    }

    bucket_key_enabled = true

  }

}
