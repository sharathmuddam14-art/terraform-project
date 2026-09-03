############################################################
# ECR REPOSITORY POLICY
############################################################

resource "aws_ecr_repository_policy" "this" {

  for_each = {
    for repo_name, repo in var.repositories :
    repo_name => repo
    if repo.repository_policy.enabled
  }

  repository = aws_ecr_repository.this[each.key].name

  policy = jsonencode({

    Version = each.value.repository_policy.version

    Statement = [

      {

        Sid = each.value.repository_policy.statement_id

        Effect = each.value.repository_policy.effect

        Principal = {

          AWS = each.value.repository_policy.principals

        }

        Action = each.value.repository_policy.actions

      }

    ]

  })

}
