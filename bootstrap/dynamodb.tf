resource "aws_dynamodb_table" "lock_table" {

  name = "${var.project_name}-locks"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {

    name = "LockID"

    type = "S"

  }

  tags = merge(

    local.common_tags,

    {

      Name = "${var.project_name}-locks"

    }

  )

}
