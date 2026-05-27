# VPCの設定
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true #DNS名前解決をできるようにする

  tags = {
    Name = "my_vpc"
  }
}

# サブネットの設定
resource "aws_subnet" "my_subnet_public_1a" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_1a_cidr
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "my_subnet_public_a"
  }
}

resource "aws_subnet" "my_subnet_public_1c" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_1c_cidr
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "my_subnet_public_c"
  }
}

resource "aws_subnet" "my_subnet_private_1a" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_1a_cidr
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "my_subnet_private_1a"
  }
}

resource "aws_subnet" "my_subnet_private_1c" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_1c_cidr
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "my_subnet_private_1c"
  }
}

# IGWの設定
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}

# Elastic IPの設定
resource "aws_eip" "my_eip" {
  domain = "vpc"
  tags = {
    Name = "my_eip"
  }
}

# NAT Gatewayの設定
resource "aws_nat_gateway" "my_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id = aws_subnet.my_subnet_public_1a.id
  tags = {
    Name = "my_gateway"
  }
}