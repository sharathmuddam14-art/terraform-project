data "aws_iam_policy_document" "kms_policy" {

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

}
