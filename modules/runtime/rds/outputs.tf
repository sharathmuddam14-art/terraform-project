############################################################
# RDS INSTANCE OUTPUTS
############################################################

output "db_instance_id" {

  description = "RDS instance identifier"

  value = aws_db_instance.this.id

}


output "db_instance_arn" {

  description = "RDS instance ARN"

  value = aws_db_instance.this.arn

}


output "db_endpoint" {

  description = "RDS database endpoint"

  value = aws_db_instance.this.endpoint

}


output "db_port" {

  description = "RDS database port"

  value = aws_db_instance.this.port

}


output "database_name" {

  description = "Database name"

  value = aws_db_instance.this.db_name

}


############################################################
# NETWORK OUTPUTS
############################################################

output "db_subnet_group_name" {

  description = "RDS subnet group name"

  value = aws_db_subnet_group.this.name

}


output "security_group_id" {

  description = "RDS security group ID"

  value = aws_security_group.this.id

}


############################################################
# MONITORING OUTPUT
############################################################

output "monitoring_role_arn" {

  description = "RDS enhanced monitoring role ARN"

  value = (

    var.create_monitoring_role

    ? aws_iam_role.monitoring[0].arn

    : null

  )

}
