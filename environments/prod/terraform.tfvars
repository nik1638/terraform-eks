environment  = "prod"
region       = "ap-south-1"
cluster_name = "myeks"
vpc_cidr     = "10.0.0.0/16"

aws_auth_roles = [
  {
    rolearn  = "arn:aws:iam::123456789012:role/prod-eks-admin"
    username = "admin"
    groups   = ["system:masters"]
  }
]
