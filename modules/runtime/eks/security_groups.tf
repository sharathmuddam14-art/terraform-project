
############################################################
# EKS CLUSTER SECURITY GROUP
############################################################

resource "aws_security_group" "cluster" {

  name = "${local.cluster_name}-cluster-sg"

  description = (
    var.cluster_security_group_description
  )

  vpc_id = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.cluster_name}-cluster-sg"
    }
  )
}

############################################################
# EKS NODE SECURITY GROUP
############################################################

resource "aws_security_group" "node" {

  name = "${local.cluster_name}-node-sg"

  description = (
    var.node_security_group_description
  )

  vpc_id = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.cluster_name}-node-sg"
    }
  )
}

############################################################
# CLUSTER -> NODE
############################################################

resource "aws_security_group_rule" "cluster_to_node" {

  type = "egress"

  from_port = 0

  to_port = 0

  protocol = "-1"

  security_group_id = aws_security_group.cluster.id

  source_security_group_id = aws_security_group.node.id
}

############################################################
# NODE -> CLUSTER
############################################################

resource "aws_security_group_rule" "node_to_cluster" {

  type = "ingress"

  from_port = var.node_to_cluster_port

  to_port = var.node_to_cluster_port

  protocol = var.node_to_cluster_protocol

  security_group_id = aws_security_group.cluster.id

  source_security_group_id = aws_security_group.node.id
}

############################################################
# NODE -> NODE
############################################################

resource "aws_security_group_rule" "node_to_node" {

  type = "ingress"

  from_port = var.node_to_node_from_port

  to_port = var.node_to_node_to_port

  protocol = var.node_to_node_protocol

  security_group_id = aws_security_group.node.id

  source_security_group_id = aws_security_group.node.id
}

############################################################
# NODE EGRESS
############################################################

resource "aws_security_group_rule" "node_egress" {

  type = "egress"

  from_port = 0

  to_port = 0

  protocol = "-1"

  cidr_blocks = var.node_egress_cidr_blocks

  security_group_id = aws_security_group.node.id
}

############################################################
# CLUSTER EGRESS
############################################################

resource "aws_security_group_rule" "cluster_egress" {

  type = "egress"

  from_port = 0

  to_port = 0

  protocol = "-1"

  cidr_blocks = var.cluster_egress_cidr_blocks

  security_group_id = aws_security_group.cluster.id
}
