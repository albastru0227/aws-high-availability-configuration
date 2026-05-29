#!/bin/bash
dnf update -y
    
#Nginxのインストールと起動
dnf install nginx -y
systemctl start nginx
systemctl enable nginx
    
#MariaDBのインストール
dnf install mariadb105 -y

#PHPのインストールと起動
dnf install php php-fpm php-mysqlnd -y
systemctl start php-fpm
systemctl enable php-fpm

#Nginxの設定ファイルの上書き
cat > /etc/nginx/nginx.conf << 'Nginx'
${nginx_conf_content}
Nginx

#index.phpの配置
cat > /usr/share/nginx/html/index.php << 'PHP'
${index_php_content}
PHP

#style.cssの配置
cat > /usr/share/nginx/html/style.css << 'CSS'
${style_css_content}
CSS

#Nginxの再起動
systemctl restart nginx