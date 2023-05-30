################################################################################
# VPC
################################################################################

 resource "aws_vpc" "vpc" {
   cidr_block = var.vpc_cidr
 }

 resource "aws_internet_gateway" "igw" {
   vpc_id = aws_vpc.vpc.id
 }

################################################################################
# Subnet
################################################################################

 resource "aws_subnet" "public_subnet" {
   count                   = length(var.public_subnets_cidr)
   vpc_id                  = aws_vpc.vpc.id
   cidr_block              = var.public_subnets_cidr[count.index]
   availability_zone       = count.index % 2 == 0 ? "${var.region}a" : "${var.region}b"
   map_public_ip_on_launch = true
 }

 resource "aws_subnet" "private_subnet_app" {
   count             = length(var.private_subnets_cidr_app)
   vpc_id            = aws_vpc.vpc.id
   cidr_block        = var.private_subnets_cidr_app[count.index]
   availability_zone = count.index % 2 == 0 ? "${var.region}a" : "${var.region}b"
 }

 resource "aws_subnet" "private_subnet_db" {
   count             = length(var.private_subnets_cidr_db)
   vpc_id            = aws_vpc.vpc.id
   cidr_block        = var.private_subnets_cidr_db[count.index]
   availability_zone = count.index % 2 == 0 ? "${var.region}a" : "${var.region}b"
 }

################################################################################
# Routing table
################################################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

 resource "aws_route_table_association" "public_route_table_association" {
   count          = length(var.public_subnets_cidr)
   subnet_id      = aws_subnet.public_subnet[count.index].id
   route_table_id = aws_route_table.public_route_table.id
 }

resource "aws_nat_gateway" "nat_gateway_app" {
  allocation_id = aws_eip.nat_eip_app.id
  subnet_id     = aws_subnet.public_subnet[0].id
}

resource "aws_eip" "nat_eip_app" {
  domain = "vpc"
}

resource "aws_route_table" "private_route_table_app" {
  count  = length(var.private_subnets_cidr_app)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_app.id
  }
}

resource "aws_route_table_association" "private_route_association" {
  count          = length(var.private_subnets_cidr_app)
  subnet_id      = aws_subnet.private_subnet_app[count.index].id
  route_table_id = aws_route_table.private_route_table_app[count.index].id
}