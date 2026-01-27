variable "region" {
  type    = string
  default = "us-east-2"
}

variable "cluster_name" {
  type        = string
  description = "Must match the cluster_name used in the VPC stack"

}
