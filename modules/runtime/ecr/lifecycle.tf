############################################################
# ECR LIFECYCLE POLICY
############################################################

resource "aws_ecr_lifecycle_policy" "this" {

  for_each = {
    for repo_name, repo in var.repositories :
    repo_name => repo
    if repo.lifecycle.enabled
  }

  repository = aws_ecr_repository.this[each.key].name

  policy = jsonencode({

    rules = [

      ######################################################
      # UNTAGGED IMAGES
      ######################################################

      {
        rulePriority = each.value.lifecycle.untagged.priority

        description = each.value.lifecycle.untagged.description

        selection = {

          tagStatus = each.value.lifecycle.untagged.tag_status

          countType = each.value.lifecycle.untagged.count_type

          countUnit = each.value.lifecycle.untagged.count_unit

          countNumber = each.value.lifecycle.untagged.count_number

        }

        action = {

          type = each.value.lifecycle.untagged.action_type

        }

      },

      ######################################################
      # TAGGED IMAGES
      ######################################################

      {
        rulePriority = each.value.lifecycle.tagged.priority

        description = each.value.lifecycle.tagged.description

        selection = {

          tagStatus = each.value.lifecycle.tagged.tag_status

          tagPrefixList = each.value.lifecycle.tagged.tag_prefix_list

          countType = each.value.lifecycle.tagged.count_type

          countNumber = each.value.lifecycle.tagged.count_number

        }

        action = {

          type = each.value.lifecycle.tagged.action_type

        }

      }

    ]

  })

}
