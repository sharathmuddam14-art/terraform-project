data "aws_iam_policy_document" "load_balancer_controller_assume_role" {

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }
  }
}


resource "aws_iam_role" "load_balancer_controller" {

  name = "${var.cluster_name}-load-balancer-controller"

  assume_role_policy = data.aws_iam_policy_document.load_balancer_controller_assume_role.json

  tags = {
    ManagedBy = "Terraform"
    Component = "AWSLoadBalancerController"
  }
}


resource "aws_iam_role_policy_attachment" "load_balancer_controller" {

  role = aws_iam_role.load_balancer_controller.name

  policy_arn = aws_iam_policy.load_balancer_controller.arn
}
