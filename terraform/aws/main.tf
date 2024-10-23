# VPC 10
resource "aws_vpc" "vpc10" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc10"
  }
}

# VPC 20
resource "aws_vpc" "vpc20" {
  cidr_block           = "20.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc20"
  }
}

# Public Subnet na VPC10
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc10.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

# Private Subnet na VPC20
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc20.id
  cidr_block = "20.0.1.0/24"

  tags = {
    Name = "Private Subnet"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.vpc20.id
  vpc_id      = aws_vpc.vpc10.id
  auto_accept = true

  tags = {
    Name = "VPC Peering between vpc10 and vpc20"
  }
}

# Adicionar rota para VPC Peering na tabela de rotas da VPC10
resource "aws_route" "vpc10_to_vpc20" {
  route_table_id            = aws_vpc.vpc10.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc20.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Adicionar rota para VPC Peering na tabela de rotas da VPC20
resource "aws_route" "vpc20_to_vpc10" {
  route_table_id            = aws_vpc.vpc20.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc10.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}