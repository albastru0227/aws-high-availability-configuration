#踏み台EC2の設定
resource "aws_instance" "ec2_bastion" {
  ami = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id = aws_subnet.my_subnet_public_1a.id
  vpc_security_group_ids = [aws_security_group.security_group_bastion.id]
  key_name = "my-keypair"
  associate_public_ip_address = true

  tags = {
    Name = "bastion_1a"
  }
}

#WebサーバーEC2の設定
resource "aws_instance" "ec2_web" {
  ami = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id = aws_subnet.my_subnet_private_1a.id
  vpc_security_group_ids = [aws_security_group.security_group_web.id]
  key_name = "my-keypair"
  associate_public_ip_address = false

  # EC2起動時にNginxを自動インストールする
  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install nginx -y
    systemctl start nginx
    systemctl enable nginx
  EOF

  tags = {
    Name = "web_1a"
  }
}