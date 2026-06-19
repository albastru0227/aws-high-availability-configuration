#ACM設定
resource "aws_acm_certificate" "main" {
  domain_name = "${var.sub_domain}.${var.domain_name}" #使用するドメイン
  validation_method = "DNS" #検証方法

  lifecycle { 
    create_before_destroy = true #証明書を作成してから前の証明書を削除する
  }
}

# 証明書の検証完了を待つリソース
resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn
  validation_record_fqdns = [ for record in aws_route53_record.cname_record : record.fqdn ]
}