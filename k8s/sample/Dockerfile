FROM nginx:latest

# インクルード用のディレクトリ内を削除
RUN rm -f /etc/nginx/conf.d/*

# Nginxの設定ファイルをコンテナにコピー
ADD k8s/sample/nginx.conf /etc/nginx/conf.d/webapp.conf
ADD k8s/sample/index.html /usr/share/nginx/html/

# ビルド完了後にNginxを起動
CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf