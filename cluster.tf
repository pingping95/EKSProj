resource "aws_eks_cluster" "cluster" {
  name                      = "${local.name_prefix}-cluster"
  role_arn                  = aws_iam_role.cluster.arn
  version                   = var.eks_version
  enabled_cluster_log_types = var.eks_enabled_log_types

  vpc_config {
    subnet_ids              = flatten([module.main_vpc.public_subnets_ids, module.main_vpc.private_subnets_ids])
    security_group_ids      = [aws_security_group.eks_cluster_sg.id, aws_security_group.eks_worker_sg.id]
    endpoint_private_access = "true"
    endpoint_public_access  = "true"
  }

  tags = {
    Name        = "${local.name_prefix}-cluster"
    Environment = var.tags.Environment
    Owner       = var.owner_tag
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.cluster
  ]
}


resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/${local.name_prefix}/cluster"
  retention_in_days = 7

  tags = {
    Name        = "${local.name_prefix}-cluster"
    Environment = var.tags.Environment
    Owner       = var.owner_tag
  }
}

resource "aws_iam_role" "cluster" {
  name = "${local.name_prefix}-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// Policies attached to EKS Cluster
// 1. EKSClusterPolicy, 2. EKSServicePolicy, 3. EKSVPCResourceController
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}