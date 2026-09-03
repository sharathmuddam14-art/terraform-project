############################################################
# DB PARAMETER GROUP
############################################################

resource "aws_db_parameter_group" "this" {

  name = "${local.name_prefix}-parameter-group"

  family = var.parameter_group_family

  description = "${local.name_prefix} parameter group"

  dynamic "parameter" {

    for_each = var.parameters

    content {

      name = parameter.value.name

      value = parameter.value.value

      apply_method = parameter.value.apply_method

    }

  }

  tags = merge(

    local.common_tags,

    {

      Name = "${local.name_prefix}-parameter-group"

    }

  )

}
