cluster_name = "demo-eks-cluster"

cluster_role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role"

node_role_arn = "arn:aws:iam::123456789012:role/eks-node-role"

public_subnet_ids = [
  "subnet-0a111111111111111",
  "subnet-0b222222222222222"
]

private_subnet_ids = [
  "subnet-0c333333333333333",
  "subnet-0d444444444444444"
]
