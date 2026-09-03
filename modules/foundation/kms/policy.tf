data "aws_iam_policy_document" "kms_policy" {


  #################################################
  # Account Root Permissions
  #################################################

  statement {

    sid = "EnableRootPermissions"

    effect = "Allow"

    principals {

      type = "AWS"

      identifiers = [

        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"

      ]

    }

    actions = [

      "kms:*"

    ]

    resources = [

      "*"

    ]

  }


  #################################################
  # CloudWatch Logs Permissions
  #################################################

  statement {

    sid = "AllowCloudWatchLogs"

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [

        "logs.${data.aws_region.current.name}.amazonaws.com"

      ]

    }

    actions = [

      "kms:Encrypt",

      "kms:Decrypt",

      "kms:ReEncrypt*",

      "kms:GenerateDataKey*",

      "kms:DescribeKey"

    ]

    resources = [

      "*"

    ]

  }

}
