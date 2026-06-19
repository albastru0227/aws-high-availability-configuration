# SNSトピックの設定（CloudWatch～Lambda）
resource "aws_sns_topic" "my_topic_to_lambda" {
  name = "my-topic-to-lambda"
}

# SNSサブスクリプションの設定
resource "aws_sns_topic_subscription" "my_subscription_to_lambda" {
  topic_arn = aws_sns_topic.my_topic_to_lambda.arn
  protocol  = "lambda"
  endpoint  =  aws_lambda_function.to_sns_function.arn #送信先となるLambdaのid
}

# SNSトピックの設定（Lambda～メール）
resource "aws_sns_topic" "my_topic_to_email" {
  name = "my-topic-to-email"
}

# SNSサブスクリプションの設定
resource "aws_sns_topic_subscription" "my_subscription" {
  topic_arn = aws_sns_topic.my_topic_to_email.arn
  protocol  = "email"
  endpoint  = var.email_address
}