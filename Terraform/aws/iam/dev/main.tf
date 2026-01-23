provider "aws" {

        region = var.region

}

module "iam" {
        source = "/mnt/d/Terraform/modules/iam"
}