provider "aws" {

        region = var.region

}

#create a vpc first

module "vpc" {

        source = "/mnt/d/Terraform/modules/vpc"
        vpc_cidr = var.vpc_cidr
        cluster_name = var.cluster_name
        public_subnet_cidr  = var.public_subnet_cidr
        private_subnet_cidr = var.private_subnet_cidr
}