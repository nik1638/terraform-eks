provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "redis" {
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  namespace  = var.namespace
  values     = lookup(var.values, "redis", {})
  create_namespace = true
}

resource "helm_release" "kafka" {
  name       = "kafka"
  repository = "https://strimzi.io/charts"
  chart      = "strimzi-kafka-operator"
  namespace  = var.namespace
  values     = lookup(var.values, "kafka", {})
  create_namespace = false
}

resource "helm_release" "prometheus_stack" {
  name       = "prom-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace
  values     = lookup(var.values, "prometheus", {})
  create_namespace = false
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.namespace
  values     = lookup(var.values, "grafana", {})
  depends_on = [helm_release.prometheus_stack]
}
