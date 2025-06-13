# modulos/red/main.tf
resource "aws_vpc" "mean_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "mean-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.mean_vpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1${count.index == 0 ? "a" : "b"}"

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_security_group" "allow_ssh_http_mongo" {
  name        = "allow_ssh_http_mongo"
  description = "Permitir SSH, HTTP y MongoDB"
  vpc_id      = aws_vpc.mean_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # regla para acceder desde afuera porr el puerrto 3000

  }

  tags = {
    Name = "allow_ssh_http_mongo"
  }
}

resource "aws_internet_gateway" "mean_igw" {
  vpc_id = aws_vpc.mean_vpc.id

  tags = {
    Name = "mean-internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.mean_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mean_igw.id
  }

  tags = {
    Name = "mean-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_assoc_0" {
  subnet_id      = aws_subnet.public_subnets[0].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_assoc_1" {
  subnet_id      = aws_subnet.public_subnets[1].id
  route_table_id = aws_route_table.public_route_table.id
}
