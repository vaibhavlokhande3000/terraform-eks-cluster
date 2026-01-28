resources "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

vpc_config {

    subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

resources "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "private-node-group"
  node_role_arn   = var.node_role_arn

  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

instance_types = ["t2.medium"]

###Adding sg

# Security Group
resources "aws_security_group" "app_sg" {
  name        = "${var.cluster_name}-app-sg"
  description = "Allow ports 5000 and 8080"
  vpc_id      = var.vpc_id

  ingress { 
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-app-sg"
  }
}

# Attach it to the Cluster
resources "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    # Add the new Security Group here
    security_group_ids      = [aws_security_group.app_sg.id]
    
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
  }
}
depends_on = [
    aws_eks_cluster.this
  ]

}

