############################################################
# KARPENTER IAM ROLE
############################################################

output "karpenter_role_arn" {

  description = "Karpenter controller IAM role ARN"

  value = aws_iam_role.controller.arn
}

############################################################
# INTERRUPTION QUEUE
############################################################

output "queue_name" {

  description = "Karpenter interruption queue name"

  value = aws_sqs_queue.karpenter.name
}

output "queue_arn" {

  description = "Karpenter interruption queue ARN"

  value = aws_sqs_queue.karpenter.arn
}
