############################################################
# RDS SUBNET GROUP
############################################################

resource "aws_db_subnet_group" "this" {

  name = "${local.name_prefix}-db-subnet-group"

  description = "RDS subnet group for ${local.name_prefix}"

  subnet_ids = var.private_subnet_ids

  tags = merge(

    local.common_tags,

    {

      Name = "${local.name_prefix}-db-subnet-group"

    }

  )

}
