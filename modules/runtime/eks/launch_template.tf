############################################################
# EKS LAUNCH TEMPLATE
############################################################

resource "aws_launch_template" "this" {

  count = var.enable_launch_template ? 1 : 0

  name_prefix = "${local.cluster_name}-"

  update_default_version = true

  ##########################################################
  # IMDS
  ##########################################################

  metadata_options {

    http_endpoint = var.imds_http_endpoint

    http_tokens = var.imds_http_tokens

    http_put_response_hop_limit = (
      var.imds_hop_limit
    )

    instance_metadata_tags = (
      var.imds_instance_metadata_tags
    )
  }

  ##########################################################
  # ROOT VOLUME
  ##########################################################

  block_device_mappings {

    device_name = "/dev/xvda"

    ebs {

      volume_size = var.root_volume_size

      volume_type = var.root_volume_type

      encrypted = var.root_volume_encrypted

      delete_on_termination = (
        var.delete_root_volume_on_termination
      )
    }
  }

  ##########################################################
  # MONITORING
  ##########################################################

  monitoring {

    enabled = var.enable_detailed_monitoring
  }

  ##########################################################
  # TAGS
  ##########################################################

  tag_specifications {

    resource_type = "instance"

    tags = local.common_tags
  }

  tag_specifications {

    resource_type = "volume"

    tags = local.common_tags
  }

  tags = local.common_tags
}
