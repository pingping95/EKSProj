#####
# Additional IAM roles and policies for service running inside EKS
# All IAM roles in this configuration make use of OIDC provider
#####

// 1. AWS Load Balancer Controller Service Account
resource "aws_iam_role" "load_balancer_controller" {
  name = "${local.name_prefix}-load-balancer-controller-role"

  assume_role_policy = templatefile(
    "${path.module}/policies/oidc_assume_role_policy.json",
    {
      OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn,
      OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""),
      NAMESPACE = "kube-system",
    SA_NAME = "aws-load-balancer-controller" }
  )

  tags = {
    "ServiceAccountName"      = "aws-load-balancer-controller"
    "ServiceAccountNameSpace" = "kube-system"
  }

  depends_on = [aws_iam_openid_connect_provider.cluster]
}

resource "aws_iam_role_policy" "load_balancer_controller" {
  name   = "${local.name_prefix}-load-balancer-controller-policy"
  role   = aws_iam_role.load_balancer_controller.id
  policy = data.aws_iam_policy_document.load_balancer_controller.json
}

// 2. Cluster_autoscaler Service Account
resource "aws_iam_role" "cluster_autoscaler" {
  name = "${local.name_prefix}-cluster-autoscaler-role"

  assume_role_policy = templatefile(
    "${path.module}/policies/oidc_assume_role_policy.json",
    {
      OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn,
      OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""),
      NAMESPACE = "kube-system",
    SA_NAME = "cluster-autoscaler" }
  )

  tags = {
    "ServiceAccountName"      = "cluster-autoscaler"
    "ServiceAccountNameSpace" = "kube-system"
  }

  depends_on = [aws_iam_openid_connect_provider.cluster]
}

resource "aws_iam_role_policy" "cluster_autoscaler" {
  name   = "${local.name_prefix}-cluster-autoscaler-policy"
  role   = aws_iam_role.cluster_autoscaler.id
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

// 3. External_secrets Service Account
resource "aws_iam_role" "external_secrets" {
  name = "${local.name_prefix}-external-secrets-role"

  assume_role_policy = templatefile(
    "${path.module}/policies/oidc_assume_role_policy.json",
    {
      OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn,
      OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""),
      NAMESPACE = "kube-system",
    SA_NAME = "external-secrets" }
  )

  tags = {
    "ServiceAccountName"      = "external-secrets"
    "ServiceAccountNameSpace" = "kube-system"
  }

  depends_on = [aws_iam_openid_connect_provider.cluster]
}

resource "aws_iam_role_policy" "external_secrets" {
  name   = "${local.name_prefix}-external-secrets-policy"
  role   = aws_iam_role.external_secrets.id
  policy = data.aws_iam_policy_document.external_secrets.json
}


# 4. External DNS Service Account
resource "aws_iam_role" "external_dns" {
  name = "${local.name_prefix}-external-dns-role"

  assume_role_policy = templatefile(
    "${path.module}/policies/oidc_assume_role_policy.json",
    {
      OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn,
      OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""),
      NAMESPACE = "kube-system",
    SA_NAME = "external-dns" }
  )

  tags = {
    "ServiceAccountName"      = "external-dns"
    "ServiceAccountNameSpace" = "kube-system"
  }

  depends_on = [aws_iam_openid_connect_provider.cluster]
}

resource "aws_iam_role_policy" "external_dns" {
  name   = "${local.name_prefix}-external-dns-policy"
  role   = aws_iam_role.external_dns.id
  policy = data.aws_iam_policy_document.external_dns.json
}

# 5. Cloudwatch-agent Service Account
resource "aws_iam_role" "cloudwatch_agent" {
  name = "${local.name_prefix}-cloudwatch-agent-role"

  assume_role_policy = templatefile(
    "${path.module}/policies/oidc_assume_role_policy.json",
    {
      OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn,
      OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""),
      NAMESPACE = "amazon-cloudwatch",
    SA_NAME = "cloudwatch-agent" }
  )

  tags = {
    "ServiceAccountName"      = "cloudwatch-agent"
    "ServiceAccountNameSpace" = "amazon-cloudwatch"
  }

  depends_on = [aws_iam_openid_connect_provider.cluster]

  lifecycle {
    # ignore_changes = [
    #   name
    # ]
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.cloudwatch_agent.name
}


# 6. EBS CSI Driver
resource "aws_iam_role" "csi_driver" {
  name = "${local.name_prefix}-csi-driver-role"

  assume_role_policy = templatefile(
    "${path.module}/policies/oidc_assume_role_policy.json",
    {
      OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn,
      OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""),
      NAMESPACE = "kube-system",
    SA_NAME = "ebs-csi-controller-sa" }
  )

  tags = {
    "ServiceAccountName"      = "ebs-csi-controller-sa"
    "ServiceAccountNameSpace" = "kube-system"
  }

  depends_on = [aws_iam_openid_connect_provider.cluster]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "csi_driver" {
  name   = "${local.name_prefix}-csi-driver-policy"
  role   = aws_iam_role.csi_driver.id
  policy = data.aws_iam_policy_document.csi_driver.json
}

# 7. EFS CSI Driver
resource "aws_iam_role" "efs_csi_driver" {
  name = "${local.name_prefix}-efs-csi-driver-role"

  assume_role_policy = templatefile(
    "${path.module}/policies/oidc_assume_role_policy.json",
    {
      OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn,
      OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""),
      NAMESPACE = "kube-system",
    SA_NAME = "efs-csi-controller-sa" }
  )

  tags = {
    "ServiceAccountName"      = "efs-csi-controller-sa"
    "ServiceAccountNameSpace" = "kube-system"
  }

  depends_on = [aws_iam_openid_connect_provider.cluster]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "efs_csi_driver" {
  name   = "${local.name_prefix}-efs-csi-driver-policy"
  role   = aws_iam_role.csi_driver.id
  policy = data.aws_iam_policy_document.csi_driver.json
}