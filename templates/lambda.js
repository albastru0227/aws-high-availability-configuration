// SNSクライアントの準備
const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns") // SNSClientはSNSを操作するクライアント、PublishCommandはメッセージを送信するクライアント
const client = new SNSClient({region: "ap-northeast-1"})

//ハンドラー関数の定義
exports.handler = async (event) => { // eventにはSNSから渡されたデータが入る
  // CloudWatchのデータをSNSから受け取り、JSON形式に変換
  const snsMessage = event.Records[0].Sns.Message; //SNSから渡されたデータの中からCloudWatchアラームの詳細情報を取り出す
  const alarm = JSON.parse(snsMessage); // 文字列型のデータをJSON形式にする

  //日本語メッセージの作成
  const message = `
  【AWSアラート通知】
  アラーム名：${alarm.AlarmName}
  現在の状態：${alarm.NewStateValue}
  発生時刻：${alarm.StateChangeTime}
  詳細：${alarm.NewStateReason}
  `.trim(); //先頭と末尾の余分な改行を除去する

  // SNSへの送信
  await client.send(new PublishCommand({
    TopicArn: process.env.SNS_TOPIC_ARN, // Lambda環境変数よりメールへ通知を行うSNSのARNを取得
    Subject: `【AWS】${alarm.AlarmName}が${alarm.NewStateValue}状態になりました`, //メールの題名
    Message: message //本文の内容
  }));
}