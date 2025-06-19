#!/bin/bash
set -euo pipefail

DOMAIN="${DOMAIN_NAME:-kbaridon.42.fr}"
CERT_CRT="${CERT_CRT:-/etc/ssl/certs/nginx-selfsigned.crt}"
CERT_KEY="${CERT_KEY:-/etc/ssl/private/nginx-selfsigned.key}"
NGINX_SITE="/etc/nginx/sites-available/default"

if [[ ! -f "$CERT_CRT" || ! -f "$CERT_KEY" ]]; then
  mkdir -p "$(dirname "$CERT_KEY")"
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout "$CERT_KEY" \
    -out   "$CERT_CRT" \
    -subj  "/C=MO/L=KH/O=1337/OU=student/CN=$DOMAIN"
fi

cat > "$NGINX_SITE" <<EOF
server {
    listen 80;
    listen [::]:80;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name ${DOMAIN} www.${DOMAIN};

    ssl_certificate     ${CERT_CRT};
    ssl_certificate_key ${CERT_KEY};
    ssl_protocols       TLSv1.3;

    root  /var/www/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        include fastcgi.conf;
        fastcgi_pass wordpress:9000;
    }
}
EOF

nginx -t
exec nginx -g "daemon off;"
