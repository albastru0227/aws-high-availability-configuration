<?php
  //MySQLに接続するためにPDOを用いる
  $host = "${db_host}";
  $dbname = "${db_name}";
  $username = "${db_username}";
  $password = "${db_password}";
  $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);

  if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // ポストされた値を変数として受け取る
    $name = $_POST['name'];
    $email = $_POST['email'];

    //データをＲＤＳに保存する処理
    $sql = "insert into users (name, email) values (:name, :email)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
            ':name' => $name,
            ':email' => $email
    ]);

    //ページにリダイレクトすることで、リロード時に同じデータが入力されないようにする
    header('location: index.php');
    exit;
  }

  //入力されたusernameとemailを表示させる
  $sql = 'select * from users';
  $stmt = $pdo->query($sql);
  $users = $stmt->fetchAll();
?>

<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>ページタイトル</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <table>
    <tr>
      <th>ID</th>
      <th>名前</th>
      <th>メール</th>
    </tr>
<?php foreach ($users as $user):?>
    <tr>
      <td><?php echo $user['id']; ?></td>
      <td><?php echo $user['name']; ?></td>
      <td><?php echo $user['email']; ?></td>
    </tr>
<?php endforeach; ?>
  </table>
  <form method="POST">
    <label>名前：</label>
    <input type="text" name="name">
    <label>E-mail：</label>
    <input type="email" name="email">
    <button type="submit">登録</button>
  </form>
</body>
</html>
