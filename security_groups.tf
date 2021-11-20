// 1. Common SSH From Bastion
resource "aws_security_group" "common_ssh" {
  name        = "${local.name_prefix}-common_ssh"
  description = "Allow SSH Inbound from bastion"
  vpc_id      = module.main_vpc.vpc_id // Network Configuration
  tags = {
    Name = "${local.name_prefix}-common_ssh"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
    description     = "Allow ssh inbound from bastion"
  }

  depends_on = [
    aws_security_group.bastion
  ]

  lifecycle {
    create_before_destroy = true
  }
}

// 2. Bastion SG
resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-bastion-sg"
  description = "Public EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id // Network Configuration
  tags = {
    Name = "${local.name_prefix}-bastion-sg"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

// [Rule] Bastion SG Inbound
resource "aws_security_group_rule" "bastion_cidrs" {
  # count             = length(var.bastion_ingress_rules)
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "SSH Inbound"
}

// 3. VPC Endpoint SG
resource "aws_security_group" "vpc_endpoint" {
  name        = "${local.name_prefix}-vpc-endpoint-sg"
  description = "Security Group used by VPC Endpoints."
  vpc_id      = module.main_vpc.vpc_id // Network Configuration

  tags = {
    "Name" = "${local.name_prefix}-vpc-endpoint-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// [Rule] VPC Endpoint
resource "aws_security_group_rule" "vpc_endpoint_egress" {
  security_group_id = aws_security_group.vpc_endpoint.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]

  depends_on = [
    aws_security_group.vpc_endpoint
  ]
}

resource "aws_security_group_rule" "vpc_endpoint_self_ingress" {
  security_group_id        = aws_security_group.vpc_endpoint.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.vpc_endpoint.id

  depends_on = [
    aws_security_group.vpc_endpoint
  ]
}


// EKS Cluster SG
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${local.name_prefix}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = module.main_vpc.vpc_id // Network Configuration

  tags = {
    Name = "${local.name_prefix}-cluster-sg"
  }
}

// [Rule] Inbound
resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_worker_sg.id

  depends_on = [
    aws_security_group.eks_cluster_sg
  ]
}

resource "aws_security_group_rule" "vpc_endpoint_eks_cluster_sg" {
  description              = "Allow EKS Security Group to communicate through vpc endpoints."
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpc_endpoint.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id

  depends_on = [
    aws_security_group.eks_cluster_sg
  ]
}

// [Rule] Outbound
resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  type                     = "egress"
  from_port                = 1024
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_worker_sg.id

  depends_on = [
    aws_security_group.eks_cluster_sg
  ]
}

// EKS Worker SG
resource "aws_security_group" "eks_worker_sg" {
  name        = "${local.name_prefix}-worker-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = module.main_vpc.vpc_id // Network Configuration

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                     = "${local.name_prefix}-worker-node-sg"
    "kubernetes.io/cluster/${local.cluster}" = "owned"
  }
}

// [Rule] Ingress
resource "aws_security_group_rule" "nodes" {
  description              = "Allow nodes to communicate with each other"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_worker_sg.id
  source_security_group_id = aws_security_group.eks_worker_sg.id

  depends_on = [
    aws_security_group.eks_worker_sg
  ]
}

resource "aws_security_group_rule" "nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_worker_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id

  depends_on = [
    aws_security_group.eks_worker_sg
  ]
}

// [Rule] EFS File System
resource "aws_security_group" "efs" {
  name        = "${local.name_prefix}-efs-sg"
  description = "Security group for EFS File system"
  vpc_id      = module.main_vpc.vpc_id // Network Configuration

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-efs-sg"
  }
}

// [Rule] EFS File system - Ingress
resource "aws_security_group_rule" "efs" {
  description       = "Allow from client to EFS File system"
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  security_group_id = aws_security_group.efs.id
  cidr_blocks       = [module.main_vpc.vic_cidr_block]

  depends_on = [
    aws_security_group.eks_worker_sg
  ]
}