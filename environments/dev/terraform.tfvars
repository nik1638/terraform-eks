environment  = "dev"
region       = "us-east-1"
cluster_name = "myeks"
vpc_cidr     = "10.0.0.0/16"

aws_auth_roles = [
  {
    rolearn  = "arn:aws:iam::123456789012:role/dev-eks-admin"
    username = "admin"
    groups   = ["system:masters"]
  }
]
