############################################################
# EKS CLUSTER IAM ROLE
############################################################

resource "aws_iam_role" "eks_cluster" {

  name = "${local.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }

    ]
  })

  tags = local.common_tags
}

############################################################
# EKS CLUSTER POLICY
############################################################

resource "aws_iam_role_policy_attachment" "cluster_policy" {

  role = aws_iam_role.eks_cluster.name

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
}

############################################################
# EKS VPC CONTROLLER POLICY
############################################################

resource "aws_iam_role_policy_attachment" "cluster_vpc_controller" {

  role = aws_iam_role.eks_cluster.name

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSVPCResourceController"
}

############################################################
# EKS NODE IAM ROLE
############################################################

resource "aws_iam_role" "eks_node" {

  name = "${local.cluster_name}-node-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }

    ]
  })

  tags = local.common_tags
}

############################################################
# NODE POLICIES
############################################################

resource "aws_iam_role_policy_attachment" "worker_node" {

  role = aws_iam_role.eks_node.name

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

############################################################
# VPC CNI POLICY
############################################################

resource "aws_iam_role_policy_attachment" "cni" {

  role = aws_iam_role.eks_node.name

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
}

############################################################
# ECR PULL POLICY
############################################################

resource "aws_iam_role_policy_attachment" "ecr_pull" {

  role = aws_iam_role.eks_node.name

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

############################################################
# SSM POLICY
############################################################

resource "aws_iam_role_policy_attachment" "ssm" {

  role = aws_iam_role.eks_node.name

  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
