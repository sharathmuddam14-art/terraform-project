# ==============================================================
# OIDC Identity Providers (e.g., GitHub Actions, GitLab CI)
# ==============================================================

resource "aws_iam_openid_connect_provider" "providers" {
  for_each = var.oidc_providers

  url             = each.value.url
  client_id_list  = each.value.client_id_list
  thumbprint_list = each.value.thumbprint_list

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.key}-oidc"
  })
}

# ==============================================================
# Roles federated via OIDC (assumed by CI/CD, not by IAM users)
# ==============================================================

resource "aws_iam_role" "oidc_roles" {
  for_each = var.oidc_roles

  name               = "${local.name_prefix}-${each.key}-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role[each.key].json

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.key}-oidc-role"
  })
}

# ==============================================================
# OIDC Role Policy Attachments
# ==============================================================

resource "aws_iam_role_policy_attachment" "oidc_attachments" {
  for_each = var.oidc_role_policy_attachments

  role       = aws_iam_role.oidc_roles[each.value.oidc_role_key].name
  policy_arn = aws_iam_policy.policies[each.value.policy_key].arn
}



# ==============================================================
# Standard IAM Outputs
# ==============================================================

output "role_arns" {
  description = "Map of standard IAM role keys to their corresponding ARNs"
  value = {
    for k, v in aws_iam_role.roles : k => v.arn
  }
}

output "role_names" {
  description = "Map of standard IAM role keys to their corresponding names"
  value = {
    for k, v in aws_iam_role.roles : k => v.name
  }
}

output "policy_arns" {
  description = "Map of standard IAM policy keys to their corresponding ARNs"
  value = {
    for k, v in aws_iam_policy.policies : k => v.arn
  }
}

# ==============================================================
# OIDC Federation Outputs
# ==============================================================

output "oidc_provider_arns" {
  description = "Map of OIDC provider keys to their corresponding ARNs"
  value = {
    for k, v in aws_iam_openid_connect_provider.providers : k => v.arn
  }
}

output "oidc_role_arns" {
  description = "Map of OIDC role keys to their corresponding ARNs"
  value = {
    for k, v in aws_iam_role.oidc_roles : k => v.arn
  }
}
