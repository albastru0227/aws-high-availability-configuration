#Route53のドメインを取得
data "aws_route53_zone" "main" {
  name = var.domain_name
  private_zone = false
}

#Route53のCNANEレコード設定
resource "aws_route53_record" "cname_record" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
        name = dvo.resource_record_name
        record = dvo.resource_record_value
        type = dvo.resource_record_type
    } 
  }

  allow_overwrite = true #同じ名前のレコードがあっても上書きする
  name = each.value.name
  records = [ each.value.record ]
  type = each.value.type
  ttl = 60
  zone_id = data.aws_route53_zone.main.zone_id
}

# Route53のAレコード設定
resource "aws_route53_record" "a_record" {
  name = "${var.sub_domain}.${var.domain_name}" #アクセスするドメイン名
  type = "A" #レコードタイプ
  zone_id = data.aws_route53_zone.main.zone_id #Route53のホストゾーンのID

  alias {
    name = aws_alb.my_alb.dns_name # Aレコードを紐づけるALBの名前
    zone_id = aws_alb.my_alb.zone_id #ALBのホストゾーンID
    evaluate_target_health = true # ALB配下のEC2がすべて不健全な場合、ALBにつながない
  } 
}