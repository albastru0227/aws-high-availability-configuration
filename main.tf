# プロバイダーの設定
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws" #HashiCorp社が提供しているAWSプロバイダーを使うことを指定
        version = "~> 5.0" #プロバーダーのバージョン（5.0以上、6.0未満）
    }
  }
}

provider "aws" {
  region = var.region
  profile = "myprofile"
}