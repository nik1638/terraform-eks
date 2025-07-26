data "aws_availability_zones" "available" {}

locals {
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  tags           = { Environment = var.environment, Terraform = "true" }
  cluster_prefix = "${var.cluster_name}-${var.environment}"
}
