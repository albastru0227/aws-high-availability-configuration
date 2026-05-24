resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true #DNS名前解決をできるようにする

  tags = {
    Name = "my_vpc"
  }
}