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

# DB用サブネット
resource "aws_subnet" "db_subnet_1a" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.db_subnet_1a_cidr
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "db_subnet_1a"
  }
}

resource "aws_subnet" "db_subnet_1c" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.db_subnet_1c_cidr
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "db_subnet_1c"
  }
}

# IGWの設定
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}

# 1aのNAT Gateway用のElastic IPの設定
resource "aws_eip" "my_eip_1a" {
  domain = "vpc"
  tags = {
    Name = "my_eip_1a"
  }
}

# NAT Gatewayの設定（ap-northeast-1a）
resource "aws_nat_gateway" "my_nat_gateway_1a" {
  allocation_id = aws_eip.my_eip_1a.id
  subnet_id = aws_subnet.my_subnet_public_1a.id
  tags = {
    Name = "my_nat_gateway_1a"
  }
}

# 1cのNAT Gateway用のElastic IPの設定
resource "aws_eip" "my_eip_1c" {
  domain = "vpc"
  tags = {
    Name = "my_eip_1c"
  }
}

# NAT Gatewayの設定（ap-northeast-1c）
resource "aws_nat_gateway" "my_nat_gateway_1c" {
  allocation_id = aws_eip.my_eip_1c.id
  subnet_id = aws_subnet.my_subnet_public_1c.id
  tags = {
    Name = "my_nat_gateway_1c"
  }
}

# ルートテーブルの設定
resource "aws_route_table" "my_route_table_public" {
  vpc_id = aws_vpc.my_vpc.id
  route { # route = {}ではない
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "my_route_table_public"
  }
}

resource "aws_route_table" "my_route_table_private_1a" {
  vpc_id = aws_vpc.my_vpc.id
  route { # route = {}ではない
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway_1a.id
  }
  tags = {
    Name = "my_route_table_private_1a"
  }
}

resource "aws_route_table" "my_route_table_private_1c" {
  vpc_id = aws_vpc.my_vpc.id
  route { # route = {}ではない
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway_1c.id
  }
  tags = {
    Name = "my_route_table_private_1c"
  }
}

# ルートテーブルとサブネットの関連付けの設定
resource "aws_route_table_association" "public_1a" {
  subnet_id = aws_subnet.my_subnet_public_1a.id
  route_table_id = aws_route_table.my_route_table_public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id = aws_subnet.my_subnet_public_1c.id
  route_table_id = aws_route_table.my_route_table_public.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id = aws_subnet.my_subnet_private_1a.id
  route_table_id = aws_route_table.my_route_table_private_1a.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id = aws_subnet.my_subnet_private_1c.id
  route_table_id = aws_route_table.my_route_table_private_1c.id
}