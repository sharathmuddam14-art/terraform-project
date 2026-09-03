############################################################
# KARPENTER CONTROLLER ROLE
############################################################

resource "aws_iam_role" "controller" {

  name = "${local.name_prefix}-controller"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Federated = var.oidc_provider_arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"
        condition = {
          "${replace(var.oidc_provider_arn, "https://", "")}:sub" = "system:serviceaccount:${var.karpenter_namespace}:karpenter"
        }
      }
    ]
  })

  tags = local.common_tags
}

############################################################
# KARPENTER CONTROLLER POLICY
############################################################

resource "aws_iam_policy" "controller" {

  name = "${local.name_prefix}-controller-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [

          "ec2:*",

          "pricing:GetProducts",

          "iam:PassRole",

          "iam:GetInstanceProfile",

          "iam:CreateInstanceProfile",

          "iam:AddRoleToInstanceProfile",

          "iam:RemoveRoleFromInstanceProfile",

          "iam:DeleteInstanceProfile",

          "iam:TagInstanceProfile",

          "ssm:GetParameter",

          "eks:DescribeCluster"
        ]

        Resource = "*"
      }
    ]
  })

  tags = local.common_tags
}

############################################################
# ATTACH POLICY
############################################################

resource "aws_iam_role_policy_attachment" "controller" {

  role = aws_iam_role.controller.name

  policy_arn = aws_iam_policy.controller.arn
}
