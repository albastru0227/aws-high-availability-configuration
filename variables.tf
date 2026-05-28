variable "region" {
  description = "プロバイダーのリージョン"
  type = string
  default = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_1a_cidr" {
  description = "AZがap-northeast-1aのパブリックサブネットのCIDR"
  type = string
  default = "10.0.1.0/24"
}

variable "public_subnet_1c_cidr" {
  description = "AZがap-northeast-1cのパブリックサブネットのCIDR"
  type = string
  default = "10.0.2.0/24"
}

variable "private_subnet_1a_cidr" {
  description = "AZがap-northeast-1aのプライベートサブネットのCIDR"
  type = string
  default = "10.0.10.0/24"
}

variable "private_subnet_1c_cidr" {
  description = "AZがap-northeast-1cのプライベートサブネットのCIDR"
  type = string
  default = "10.0.20.0/24"
}

variable "ip_address_ssh" {
  description = "EC2へSSH接続可能なIPアドレス"
  type = string
  sensitive = true
}

variable "ec2_ami" {
  description = "EC2のAMI（Amazon Linux 2023）"
  type = string
  #Amazon Linux 2023 kernel-6.1 AMI（長期サポート版）
  default = "ami-0b53194d9d4d5cfea"
}

variable "ec2_instance_type" {
  description = "EC2で使うインスタンスタイプ"
  type = string
  default = "t3.micro"
}

# DB関連の変数
variable "db_subnet_1a_cidr" {
  description = "DBサブネット1aのCIDR"
  type = string
  default = "10.0.30.0/24"
}

variable "db_subnet_1c_cidr" {
  description = "DBサブネット1cのCIDR"
  type = string
  default = "10.0.40.0/24"
}

variable "db_name" {
  description = "データベースの名前"
  type = string
  default = "my_database"
}

variable "db_username" {
  description = "SQLのユーザーネーム"
  type = string
  default = "albas"
  sensitive = true
}

variable "db_password" {
  description = "SQLのパスワード"
  type = string
  sensitive = true
}