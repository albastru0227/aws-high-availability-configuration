# ターゲットグループの設定
resource "aws_alb_target_group" "my_target_group" {
  name = "my-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_target_group"
  }
}

# ALBの設定
resource "aws_alb" "my_alb" {
  name = "my-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.security_group_alb.id]
  subnets = [
    aws_subnet.my_subnet_public_1a.id,
    aws_subnet.my_subnet_public_1c.id
    ]

  tags = {
    Name = "my_alb"
  }
}

# リスナーの設定（HTTP）
resource "aws_alb_listener" "my_listener" {
  load_balancer_arn = aws_alb.my_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "redirect" #HTTPSにリダイレクトする

    redirect { #リダイレクトの設定
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301" #ブラウザのURLが変更になったことを示すステータス
    }
  }
}

# リスナーの設定（HTTPS）
resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.my_alb.arn #リスナー設定をするALB
  port = "443"
  protocol = "HTTPS"

  # SSL/TLSのセキュリティポリシー
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  # ACM証明書（検証したものを渡す）
  certificate_arn = aws_acm_certificate_validation.main.certificate_arn

  # 条件に合致した際の処理の設定（今回はターゲットグループにつなぐ）
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.my_target_group.arn
  }
}