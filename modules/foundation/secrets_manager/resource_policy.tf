#################################################
# IAM Policy Document for Secrets Manager
#################################################

data "aws_iam_policy_document" "secret_policy" {

  statement {

    sid = "AllowRootAccount"

    effect = "Allow"

    principals {

      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]

    }

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:DeleteSecret"
    ]

    resources = [
      aws_secretsmanager_secret.this.arn
    ]

  }

}

#################################################
# Attach Resource Policy
#################################################

resource "aws_secretsmanager_secret_policy" "this" {

  secret_arn = aws_secretsmanager_secret.this.arn

  policy = data.aws_iam_policy_document.secret_policy.json

}
