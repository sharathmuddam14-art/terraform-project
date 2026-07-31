
# ==============================================================
# Standard IAM Outputs
# ==============================================================

# Returns the ARN of each standard IAM Role.
# Example:
# {
#   ec2    = arn:aws:iam::123456789012:role/dev-ec2-role
#   lambda = arn:aws:iam::123456789012:role/dev-lambda-role
# }
output "role_arns" {
  description = "Map of standard IAM role keys to their corresponding ARNs"

  value = {
    for k, v in aws_iam_role.roles :
    k => v.arn
  }
}

# Returns the Name of each standard IAM Role.
# Example:
# {
#   ec2    = "dev-ec2-role"
#   lambda = "dev-lambda-role"
# }
output "role_names" {
  description = "Map of standard IAM role keys to their corresponding names"

  value = {
    for k, v in aws_iam_role.roles :
    k => v.name
  }
}

# Returns the ARN of each IAM Policy.
# Example:
# {
#   ec2 = arn:aws:iam::123456789012:policy/dev-ec2-policy
#   s3  = arn:aws:iam::123456789012:policy/dev-s3-policy
# }
output "policy_arns" {
  description = "Map of standard IAM policy keys to their corresponding ARNs"

  value = {
    for k, v in aws_iam_policy.policies :
    k => v.arn
  }
}

# ==============================================================
# OIDC Federation Outputs
# ==============================================================

# Returns the ARN of each OIDC Provider.
# Example:
# {
#   github = arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com
# }
output "oidc_provider_arns" {
  description = "Map of OIDC provider keys to their corresponding ARNs"

  value = {
    for k, v in aws_iam_openid_connect_provider.providers :
    k => v.arn
  }
}

# Returns the ARN of each OIDC IAM Role.
# Example:
# {
#   github = arn:aws:iam::123456789012:role/github-actions-role
# }
output "oidc_role_arns" {
  description = "Map of OIDC role keys to their corresponding ARNs"

  value = {
    for k, v in aws_iam_role.oidc_roles :
    k => v.arn
  }
}

