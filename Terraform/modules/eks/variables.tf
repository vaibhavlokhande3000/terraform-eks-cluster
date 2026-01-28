variable "cluster_name" {}
variable "cluster_role_arn" {}
variable "node_role_arn" {}
variable "vpc_cidr" {}
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "vpc_id" { type = string}
