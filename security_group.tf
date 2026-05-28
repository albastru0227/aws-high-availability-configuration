#ALB用のセキュリティグループ
resource "aws_security_group" "security_group_alb" {
  name = "security_group_alb"
  vpc_id = aws_vpc.my_vpc.id

  #インバウンドルールの設定
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #アウトバウンドルールの設定
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_alb"
  }
}

#踏み台サーバーEC2用のセキュリティグループ
resource "aws_security_group" "security_group_bastion" {
  name = "security_group_bastion"
  vpc_id = aws_vpc.my_vpc.id

  #インバウンドルールの設定
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.ip_address_ssh]
  }

  #アウトバウンドルールの設定
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_bastion"
  }
}

#WebサーバーEC2用のセキュリティグループ
resource "aws_security_group" "security_group_web" {
  name = "security_group_web"
  vpc_id = aws_vpc.my_vpc.id

  #インバウンドルールの設定
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    #ALBからの接続のみを許可するため、CIDRではなくALBにアタッチするセキュリティグループのIDを指定する
    security_groups = [aws_security_group.security_group_alb.id]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.security_group_bastion.id]
  }

  #アウトバウンドルールの設定
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_web"
  }
}

# RDS用のセキュリティグループ
resource "aws_security_group" "security_group_rds" {
  name = "security_group_rds"
  vpc_id = aws_vpc.my_vpc.id
  
  #インバウンドルールの設定
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.security_group_web.id]
  }

  #アウトバウンドルールの設定
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security_group_rds"
  }
}