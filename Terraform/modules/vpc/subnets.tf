#subnets

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {

  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
        Name = "${var.cluster_name}-public"
        "kubernetes.io/role/elb" = "1"
  }

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.cluster_name}-private-${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }

}
