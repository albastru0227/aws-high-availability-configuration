# LambdaがAWSサービスを使えるようにする
resource "aws_iam_role" "lambda_role" {
  name = "lambda-sns-publish-role"

  # Lambdaがこのロールを引き受ける
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }
    ]
  })
}

# SNSパブリッシュ権限のポリシー定義
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-sns-publish-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = [
                "SNS:Publish"
            ]
            Effect = "Allow"
            Resource = aws_sns_topic.my_topic_to_email.arn
        }
    ]
  })
}