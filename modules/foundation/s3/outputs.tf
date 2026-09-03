#################################################
# Bucket ID
#################################################

output "bucket_id" {

  description = "S3 Bucket ID"

  value = aws_s3_bucket.this.id

}

#################################################
# Bucket Name
#################################################

output "bucket_name" {

  description = "S3 Bucket Name"

  value = aws_s3_bucket.this.bucket

}

#################################################
# Bucket ARN
#################################################

output "bucket_arn" {

  description = "S3 Bucket ARN"

  value = aws_s3_bucket.this.arn

}

#################################################
# Bucket Domain Name
#################################################

output "bucket_domain_name" {

  description = "Bucket Domain Name"

  value = aws_s3_bucket.this.bucket_domain_name

}

#################################################
# Regional Domain Name
#################################################

output "bucket_regional_domain_name" {

  description = "Regional Bucket Domain Name"

  value = aws_s3_bucket.this.bucket_regional_domain_name

}

#################################################
# Hosted Zone ID
#################################################

output "hosted_zone_id" {

  description = "Hosted Zone ID"

  value = aws_s3_bucket.this.hosted_zone_id

}

#################################################
# Bucket Region
#################################################

output "bucket_region" {

  description = "AWS Region"

  value = data.aws_region.current.name

}

#################################################
# Summary
#################################################

output "s3_summary" {

  description = "Summary of S3 Resources"

  value = {

    bucket_name = aws_s3_bucket.this.bucket

    bucket_arn = aws_s3_bucket.this.arn

    region = data.aws_region.current.name

    kms_key = var.kms_key_arn

  }

}
