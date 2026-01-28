provider "aws" {
  region = var.region
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
    values = ["${var.cluster_name}-private"]
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


###

