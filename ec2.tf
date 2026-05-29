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

  #EC2起動時に自動インストールする
  user_data = templatefile("templates/userdata.sh", {
    nginx_conf_content = file("templates/nginx.conf.tpl")
    index_php_content = templatefile("templates/index.php.tpl", {
      db_host = aws_db_instance.rds_instance.address
      db_name = var.db_name
      db_username = var.db_username
      db_password = var.db_password
    })
    style_css_content = file("templates/style.css")
  })

  tags = {
    Name = "web_1a"
  }
}

#踏み台サーバーへ自動で秘密鍵を転送する設定
resource "null_resource" "transfer_keypair" {
  #踏み台EC2が作成されることをトリガーとして実行されることを定義する
  triggers = {
    instance_id = aws_instance.ec2_bastion.id
  }

  #秘密鍵ファイルを踏み台サーバーの.sshディレクトリへ転送
  provisioner "file" {
    source = "C:/Users/albas/Downloads/my-keypair.pem"
    destination = "/home/ec2-user/.ssh/my-keypair.pem"
  }

  #転送した秘密鍵ファイルの権限を600に変更
  provisioner "remote-exec" {
    inline = [ 
      "chmod 600 /home/ec2-user/.ssh/my-keypair.pem"
     ]
  }

  #踏み台サーバーへの接続設定
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("C:/Users/albas/Downloads/my-keypair.pem")
    host = aws_instance.ec2_bastion.public_ip
  }
}