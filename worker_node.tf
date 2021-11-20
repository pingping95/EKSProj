// EKS Worker Node
resource "aws_eks_node_group" "worker" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${local.name_prefix}-worker-node"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = module.main_vpc.private_subnets_ids // Network Configuration

  // Worker Settings
  instance_types = var.worker_instance_types
  disk_size      = var.worker_disk_size

  scaling_config {
    desired_size = var.worker_size.desired
    min_size     = var.worker_size.min
    max_size     = var.worker_size.max
  }

  remote_access {
    source_security_group_ids = [aws_security_group.common_ssh.id]
    ec2_ssh_key               = var.key_pair
  }

  tags = {
    Name        = "${local.name_prefix}-worker-node"
    Environment = "${var.tags.Environment}"
    Owner       = var.owner_tag
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}


// IAM Role
resource "aws_iam_role" "worker" {
  name               = "${local.name_prefix}-managed-worker-node"
  assume_role_policy = data.aws_iam_policy_document.workers_role_assume_role_policy.json
  tags = {
    Environment = "${var.tags.Environment}"
  }
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}