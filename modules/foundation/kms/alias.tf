resource "aws_kms_alias" "this" {

  name = "alias/${var.key_alias}"

  target_key_id = aws_kms_key.this.key_id

}
