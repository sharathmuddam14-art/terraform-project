############################################################
# BACKUP CONFIGURATION
############################################################

locals {
  backup = {
    retention_period         = var.backup_retention_period
    backup_window            = var.backup_window
    maintenance_window       = var.maintenance_window
    skip_final_snapshot      = var.skip_final_snapshot
    deletion_protection      = var.deletion_protection
    copy_tags_to_snapshot    = var.copy_tags_to_snapshot
    delete_automated_backups = var.delete_automated_backups
  }
}
