#################################################
# S3 Bucket
#################################################

resource "aws_s3_bucket" "this" {

  bucket = local.bucket_name

  force_destroy = false

  tags = local.common_tags

}
