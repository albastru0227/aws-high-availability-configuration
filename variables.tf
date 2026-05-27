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