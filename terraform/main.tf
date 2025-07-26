module "vpc" {
  source   = "./modules/vpc"
  prefix   = local.cluster_prefix
  cidr     = var.vpc_cidr
  azs      = local.azs
  tags     = local.tags
}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = local.cluster_prefix
  cluster_version  = "1.29"
  #vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  public_subnets   = module.vpc.public_subnets
  aws_auth_roles   = var.aws_auth_roles
  region           = var.region
  tags             = local.tags
}

module "karpenter" {
  source            = "./modules/karpenter"
  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  oidc_provider_arn = module.eks.oidc_provider_arn
  region            = var.region
  tags              = local.tags
}

module "apps" {
  source    = "./modules/apps"
  namespace = "infra"
  values = {
    redis = {
      architecture = "standalone"
      auth = { enabled = false }
    }
    kafka = {
      kafka = { replicas = 3, storage = { type = "ephemeral" } }
      zookeeper = { replicas = 3 }
    }
    prometheus = {
      prometheus = { prometheusSpec = { storageSpec = { volumeClaimTemplate = { spec = { storageClassName = "gp2", accessModes = ["ReadWriteOnce"], resources = { requests = { storage = "10Gi" }}}}}}}
      alertmanager = { alertmanagerSpec = { storage = { volumeClaimTemplate = { spec = { resources = { requests = { storage = "2Gi" }}}}}}}
    }
    grafana = {
      adminUser     = "admin"
      adminPassword = "admin"
      persistence = { enabled = true, storageClassName = "gp2", size = "5Gi" }
    }
  }
}
