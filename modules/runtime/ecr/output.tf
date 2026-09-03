############################################################
# Repository Names
############################################################

output "repository_names" {

  description = "Map of ECR repository names"

  value = {
    for repository_name, repository in aws_ecr_repository.this :
    repository_name => repository.name
  }

}

############################################################
# Repository URLs
############################################################

output "repository_urls" {

  description = "Map of ECR repository URLs"

  value = {
    for repository_name, repository in aws_ecr_repository.this :
    repository_name => repository.repository_url
  }

}

############################################################
# Repository ARNs
############################################################

output "repository_arns" {

  description = "Map of ECR repository ARNs"

  value = {
    for repository_name, repository in aws_ecr_repository.this :
    repository_name => repository.arn
  }

}

############################################################
# Repository Registry IDs
############################################################

output "repository_registry_ids" {

  description = "Map of ECR registry IDs"

  value = {
    for repository_name, repository in aws_ecr_repository.this :
    repository_name => repository.registry_id
  }

}
