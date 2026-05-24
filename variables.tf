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