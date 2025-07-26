resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "https://charts.karpenter.sh"
  chart            = "karpenter"
  namespace        = "karpenter"
  create_namespace = true
  version          = "v0.27.1"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = "KarpenterInstanceProfile-${var.cluster_name}"
  }

  set {
    name  = "serviceAccount.annotations.eks.amazonaws.com/role-arn"
    value = "arn:aws:iam::123456789012:role/KarpenterControllerRole-${var.cluster_name}"
  }

  set {
    name  = "settings.aws.clusterName"
    value = var.cluster_name
  }
}
