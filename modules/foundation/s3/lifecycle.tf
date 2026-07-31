#################################################
# S3 Bucket Lifecycle Configuration
#################################################

resource "aws_s3_bucket_lifecycle_configuration" "this" {

  bucket = aws_s3_bucket.this.id

  rule {

    id = "lifecycle-rule"

    status = "Enabled"

    #################################################
    # Abort Incomplete Multipart Uploads
    #################################################

    abort_incomplete_multipart_upload {

      days_after_initiation = 7

    }

    #################################################
    # Expire Non-Current Object Versions
    #################################################

    noncurrent_version_expiration {

      noncurrent_days = 30

    }

  }

}
