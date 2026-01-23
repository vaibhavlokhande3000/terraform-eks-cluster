resource "aws_vpc" "this"{
        cidr_block = var.vpc_cidr
        enable_dns_hostnames = true
        enable_dns_support = true

        tags = {
                Name = "${var.cluster_name}-vpc"
                "kubernetes.io/cluster/${var.cluster_name}" = "shared"
          }
}

#subnets

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {

  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
        Name = "${var.cluster_name}-public"
        "kubernetes.io/role/elb" = "1"
  }

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.cluster_name}-private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}


#Ig and natg


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.cluster_name}-igw" }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = { Name = "${var.cluster_name}-nat" }
  depends_on = [aws_internet_gateway.igw]
}


#Route tables

resource "aws_route_table" "public"{
  vpc_id = aws_vpc.this.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

}

  tags = {Name = "${var.cluster_name}-public-rt"}

}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
}
        tags = {Name = "${var.cluster_name}-private-rt"}
}


#Associate route tables

resource "aws_route_table_association" "public"{

  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "private"{

  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id

}