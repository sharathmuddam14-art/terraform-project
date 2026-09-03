############################################################
# Registry Scanning Configuration
############################################################

resource "aws_ecr_registry_scanning_configuration" "this" {

  scan_type = var.registry_scan_type

  rule {

    scan_frequency = var.registry_scan_frequency

    repository_filter {

      filter = var.repository_filter.filter

      filter_type = var.repository_filter.filter_type

    }

  }

}
