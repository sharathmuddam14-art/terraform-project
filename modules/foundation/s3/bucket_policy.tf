#################################################
# IAM Policy Document
#################################################

data "aws_iam_policy_document" "bucket_policy" {

  #################################################
  # Deny HTTP Requests (Allow HTTPS Only)
  #################################################

  statement {

    sid    = "DenyInsecureTransport"

    effect = "Deny"

    principals {

      type        = "*"

      identifiers = ["*"]

    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    condition {

      test     = "Bool"

      variable = "aws:SecureTransport"

      values = [
        "false"
      ]

    }

  }

}

#################################################
# Attach Bucket Policy
#################################################

resource "aws_s3_bucket_policy" "this" {

  bucket = aws_s3_bucket.this.id

  policy = data.aws_iam_policy_document.bucket_policy.json

}
