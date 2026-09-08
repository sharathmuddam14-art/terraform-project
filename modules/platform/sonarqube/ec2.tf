resource "aws_instance" "this" {
  ami = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = var.private_subnet_ids[0]

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.sonarqube.name
    depends_on = [
    aws_iam_instance_profile.sonarqube
  ]

  vpc_security_group_ids = [
    aws_security_group.sonarqube.id
  ]

  user_data = templatefile("${path.module}/user_data.sh", {
  java_version      = var.java_version
  JAVA_VERSION      = var.java_version
  sonarqube_version = var.sonarqube_version
  sonarqube_port    = var.sonarqube_port
  db_name           = var.db_name
  db_user           = var.db_user
})

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }

  tags = {
    Name    = var.name
    Service = "sonarqube"
  }
}
