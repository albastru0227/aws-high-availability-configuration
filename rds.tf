#RDSサブネットグループ（RDSを配置するサブネットを決める）
resource "aws_db_subnet_group" "rds_subnet_group" {
  # nameはハイフンのみ使用可。アンダーバーは使用不可。
  name = "rds-subnet-group"
  subnet_ids = [aws_subnet.db_subnet_1a.id, aws_subnet.db_subnet_1c.id]

  tags = {
    Name = "rds_subnet_group"
  }
}

#RDSインスタンスの設定
resource "aws_db_instance" "rds_instance" {
  identifier = "rds-instance"
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"

  #ストレージ容量
  allocated_storage = 20
  db_name = var.db_name
  username = var.db_username
  password = var.db_password

  #上で記述したサブネットグループを紐づける
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.security_group_rds.id]

  #terraform destroy時にスナップショットを自動で作成しないようにする
  skip_final_snapshot = true

  tags = {
    Name = "rds_instance"
  }
}

#my_databaseにusersのテーブルを作成
resource "null_resource" "create_table" {
  #RDS作成時にトリガーが起動する
  triggers = {
    rds_id = aws_db_instance.rds_instance.id
  }

  #userテーブルの作成が完了してから実行する
  depends_on = [ 
    aws_instance.ec2_web,
    aws_db_instance.rds_instance
   ]

  #MySQLでusersテーブルを作成する
  provisioner "remote-exec" {
    inline = [ 
      "sleep 60",
      "sudo dnf install -y mariadb105",
      "mysql -h ${aws_db_instance.rds_instance.address} -P 3306 -u ${var.db_username} -p${var.db_password} ${var.db_name} -e 'create table if not exists users (id int auto_increment primary key, name varchar(100), email varchar(100));'"
    ]

    #接続設定
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("C:/Users/albas/Downloads/my-keypair.pem")
      host = aws_instance.ec2_web.private_ip

      bastion_host = aws_instance.ec2_bastion.public_ip
      bastion_user = "ec2-user"
      bastion_private_key = file("C:/Users/albas/Downloads/my-keypair.pem")
    }
  }
}