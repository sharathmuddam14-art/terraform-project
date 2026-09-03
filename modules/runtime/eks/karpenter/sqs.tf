resource "aws_sqs_queue" "karpenter" {

  name = var.interruption_queue_name

  tags = local.common_tags
}
