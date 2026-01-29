provider "aws" {
  region = var.region
}

# Configures Helm to authenticate with the EKS cluster we create
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

# 1. Get the VPC by name tag
data "aws_vpc" "eks_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-vpc"]
  }
}

# 2. Get Public Subnets
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-public"]
  }
}

# 3. Get Private Subnets
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-private-*"]
  }
}

# --- MODULES ---

module "iam" {
  source = "../../../modules/iam"
}

module "eks" {
  source = "../../../modules/eks"

  cluster_name = var.cluster_name

  # Passing IAM Roles from the IAM module
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn

  # Passing Network Info found via Data Sources
  vpc_id             = data.aws_vpc.eks_vpc.id
  vpc_cidr           = data.aws_vpc.eks_vpc.cidr_block
  public_subnet_ids  = data.aws_subnets.public.ids
  private_subnet_ids = data.aws_subnets.private.ids
}

############################################
# HELM RELEASES


# 1. Metrics Server

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = "3.12.1"

}
  set {
    name  = "metrics.enabled"
    value = false
  }


# Cluster Autoscaler
resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.37.0"



  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }


set {
    name  = "awsRegion"
    value = var.region
  }
}