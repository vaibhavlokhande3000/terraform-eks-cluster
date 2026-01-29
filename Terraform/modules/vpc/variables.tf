variable "vpc_cidr" {}
variable "cluster_name" {}
variable "public_subnet_cidr" {type = string}

variable "private_subnet_cidr" {type = list(string)}
