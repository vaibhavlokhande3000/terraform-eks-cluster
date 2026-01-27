variable "region" {
  default = "us-east-2"
}

variable "cluster_name" {
  default = "my-modular-eks-cluster"
}

variable "vpc_cidr" {}
variable "public_subnet_cidr" {}

variable "private_subnet_cidr" {}
