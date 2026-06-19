# WAFの設定
resource "aws_wafv2_web_acl" "my_waf" {
  scope = "REGIONAL" #ALBの場合はREGIONAL
  name = "my_waf"
  default_action { #ルールに一致しないトラフィックは許可
    allow {}
  }

  #WAF全体の監視設定
  visibility_config {
    cloudwatch_metrics_enabled = true #ブロック発生時にCloudWatchにデータを送信
    metric_name = "WAF-Global-Metrics"
    sampled_requests_enabled = true #GUI上でブロックされたリクエストの詳細を確認できるようにする
  }
  
  # AWSが管理しているルールセット（SQLインジェクションなどの自動検知）
  rule {
    #基本設定
    name = "aws_managed_rule"
    priority = 0 #ルールの優先度（最優先）
    visibility_config { #CloudWatchメトリクスの設定
      cloudwatch_metrics_enabled = true #WAFがブロックしたデータをCloudWatchに送信する
      metric_name = "WAF-Rule-AWS-ManagedRule-Metrics"
      sampled_requests_enabled = true #ルールに合致したリクエストの具体的な中身がGUIで確認できる
    }

    #通信の処理の設定
    override_action { #awsのマネージドルールを呼び出す場合はこちら
      none {} #ルール通りに動かす
    }

    #条件の定義
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name = "AWSManagedRulesCommonRuleSet"
      }
    }
  }

  # レートベースルール（同一IPから大量にリクエストがあった場合にブロックする）
  rule {
    #基本設定
    name = "rate_based_rule"
    priority = 1 #AWSマネージドルールの次に優先
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "WAF-RateBased-Metrics"
      sampled_requests_enabled = true
    }

    #通信処理の設定
    action { #自作ルールを呼び出す場合に使用
      block {} #ルールに合致した場合ブロックする
    }

    statement {
      rate_based_statement { #レートベース（リクエスト数）による制限
        limit =2000 # 5分間に2000回以上のアクセスがあった場合に制限
        aggregate_key_type = "IP" #リクエスト元のIPアドレスごとに回数をカウントする
      }
    }
  }
}

# 設定したWAFをALBにアタッチする
resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = aws_alb.my_alb.arn #アタッチ先のALBのARN
  web_acl_arn = aws_wafv2_web_acl.my_waf.arn #アタッチするWAFのARN
}