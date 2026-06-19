# CloudWatchアラームの作成
resource "aws_cloudwatch_metric_alarm" "my_cloudwatch" {
  # 基本設定
  alarm_name = "my-cloudwatch"
  comparison_operator = "GreaterThanOrEqualToThreshold" #閾値と実際の値の比較方法（以上）
  evaluation_periods = 1 #1回超えるとアラーム発報
  threshold = 80 #CPU使用率80%を閾値とする

  # 監視対象メトリクスの特定
  metric_name = "CPUUtilization" #CPU使用率
  namespace = "AWS/EC2" #対象AWSサービス
  period = 300 #統計を計算する期間の長さ（秒）
  statistic = "Average" #5分間の平均値を指標とする
  dimensions = { #対象とするAutoScalingグループを指定する
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  # 通知設定
  alarm_actions = [aws_sns_topic.my_topic_to_lambda.arn] #通知先となるSNSトピック
}