# Lambda関数をZIPファイル化する
data "archive_file" "to_zip" {
  type = "zip"
  source_file = "${path.module}/templates/lambda.js"
  output_path = "${path.module}/templates/lambda.zip"
}

# Lambda関数本体の設定
resource "aws_lambda_function" "to_sns_function" {
  filename = data.archive_file.to_zip.output_path #ZIP化したLambda関数のファイル
  function_name = "to-sns-function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda.handler"
  source_code_hash = data.archive_file.to_zip.output_base64sha256 #ZIPファイルのハッシュ値を渡し、変更があればLambda関数を更新する
  runtime = "nodejs20.x" #使う言語とNodeJSのバージョン

  environment {
    variables = {
      ENVIRONMENT = "production"
      SNS_TOPIC_ARN = aws_sns_topic.my_topic_to_email.arn
    }
  }
}

# SNSがLambdaを呼び出せるように許可
resource "aws_lambda_permission" "allow_sns" {
  statement_id = "AllowExecutionFromSNS"
  action = "lambda:InvokeFunction" #LambdaFunctionを実行する権限を付与
  function_name = aws_lambda_function.to_sns_function.function_name #対象のLambda関数
  principal = "sns.amazonaws.com"
  source_arn = aws_sns_topic.my_topic_to_lambda.arn #Lambdaへデータを送るSNSトピック
}