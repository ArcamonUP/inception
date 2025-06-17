#!/bin/bash

set -euo pipefail

DOMAIN="${DOMAIN_NAME:-kbaridon.42.fr}"
CERT_CRT="${CERTS_:-/etc/ssl/certs/nginx-selfsigned.crt}"
CERT_KEY="/etc/ssl/private/nginx-selfsigned.key"
NGINX_SITE="/etc/nginx/sites-available/default"

if [[ ! -f "$CERT_CRT" || ! -f "$CERT_KEY" ]]; then
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout "$CERT_KEY" \
    -out   "$CERT_CRT" \
    -subj  "/C=MO/L=KH/O=1337/OU=student/CN=$DOMAIN"
fi

cat > "$NGINX_SITE" <<EOF
server {
    listen 443 ssl;
    listen [::]:443 ssl;
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
        include fastcgi_params;
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO       \$fastcgi_path_info;
        fastcgi_index index.php;
    }
}
EOF

exec nginx -g "daemon off;"
