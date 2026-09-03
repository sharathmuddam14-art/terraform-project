############################################################
# EKS ACCESS ENTRY
############################################################

resource "aws_eks_access_entry" "current" {

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = data.aws_iam_role.terraform.arn

  type = var.access_entry_type
}

############################################################
# EKS ACCESS POLICY
############################################################

resource "aws_eks_access_policy_association" "current" {

  cluster_name  = aws_eks_cluster.this.name
  principal_arn = data.aws_iam_role.terraform.arn

  policy_arn = var.access_policy_arn

  access_scope {
    type = var.access_scope_type
  }
}
