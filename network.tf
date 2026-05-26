resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true #DNS名前解決をできるようにする

  tags = {
    Name = "my_vpc"
  }
}

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