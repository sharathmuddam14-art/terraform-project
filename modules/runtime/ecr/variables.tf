############################################################
# PROJECT NAME
############################################################

variable "project_name" {

  description = "Project name"

  type = string

}

############################################################
# ENVIRONMENT
############################################################

variable "environment" {

  description = "Environment name"

  type = string

}

############################################################
# COMMON TAGS
############################################################

variable "tags" {

  description = "Common ECR resource tags"

  type = map(string)

  default = {}

}

############################################################
# REGISTRY SCAN TYPE
############################################################

variable "registry_scan_type" {

  description = "ECR registry scan type"

  type = string

  validation {

    condition = contains(
      [
        "BASIC",
        "ENHANCED"
      ],
      var.registry_scan_type
    )

    error_message = "Registry scan type must be BASIC or ENHANCED."

  }

}

############################################################
# REGISTRY SCAN FREQUENCY
############################################################

variable "registry_scan_frequency" {

  description = "ECR registry scan frequency"

  type = string

  validation {

    condition = contains(
      [
        "SCAN_ON_PUSH",
        "CONTINUOUS_SCAN"
      ],
      var.registry_scan_frequency
    )

    error_message = "Registry scan frequency must be SCAN_ON_PUSH or CONTINUOUS_SCAN."

  }

}

############################################################
# REPOSITORY FILTER
############################################################

variable "repository_filter" {

  description = "ECR repository filter"

  type = object({

    filter      = string
    filter_type = string

  })

  validation {

    condition = contains(
      [
        "PREFIX_MATCH",
        "WILDCARD"
      ],
      var.repository_filter.filter_type
    )

    error_message = "Filter type must be PREFIX_MATCH or WILDCARD."

  }

}

############################################################
# ECR REPOSITORIES
############################################################

variable "repositories" {

  description = "ECR repository configuration"

  type = map(object({

    ########################################################
    # REPOSITORY
    ########################################################

    image_tag_mutability = string

    ########################################################
    # IMAGE SCANNING
    ########################################################

    scan_on_push = bool

    ########################################################
    # ENCRYPTION
    ########################################################

    encryption = object({

      type = string

      kms_key = optional(string)

    })

    ########################################################
    # LIFECYCLE
    ########################################################

    lifecycle = object({

      enabled = bool

      ######################################################
      # UNTAGGED IMAGES
      ######################################################

      untagged = object({

        priority     = number
        description  = string
        tag_status   = string
        count_type   = string
        count_unit   = string
        count_number = number
        action_type  = string

      })

      ######################################################
      # TAGGED IMAGES
      ######################################################

      tagged = object({

        priority        = number
        description     = string
        tag_status      = string
        tag_prefix_list = list(string)
        count_type      = string
        count_number    = number
        action_type     = string

      })

    })

    ########################################################
    # REPOSITORY POLICY
    ########################################################

    repository_policy = object({

      enabled = bool

      version = string

      statement_id = string

      effect = string

      principals = list(string)

      actions = list(string)

    })

  }))

}
