output "iam_role_arn" {

  description = "IAM role ARN used by AWS Load Balancer Controller"

  value = aws_iam_role.load_balancer_controller.arn
}


output "iam_policy_arn" {

  description = "IAM policy ARN used by AWS Load Balancer Controller"

  value = aws_iam_policy.load_balancer_controller.arn
}


output "service_account_name" {

  description = "Kubernetes ServiceAccount used by AWS Load Balancer Controller"

  value = kubernetes_service_account.load_balancer_controller.metadata[0].name
}


output "helm_release_name" {

  description = "Helm release name"

  value = helm_release.load_balancer_controller.name
}


output "helm_release_status" {

  description = "Helm release status"

  value = helm_release.load_balancer_controller.status
}
