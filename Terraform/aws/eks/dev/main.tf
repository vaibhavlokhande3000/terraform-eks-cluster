provider "aws" {

        region = var.region

}
module "iam" {
        source = "/mnt/d/Terraform/modules/iam"
}
module "eks"{

        source = "/mnt/d/Terraform/modules/eks"
        cluster_name = var.cluster_name
        cluster_role_arn = module.iam.cluster_role_arn
        node_role_arn = module.iam.node_role_arn
        public_subnet_ids = module.vpc.public_subnets
        private_subnet_ids = module.vpc.private_subnets
}