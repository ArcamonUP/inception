FROM debian:bullseye

RUN apt-get update -y && apt-get install --no-install-recommends -y \
ca-certificates curl php7.4-cli php7.4-fpm php7.4-mysql && \
apt-get clean && rm -rf /var/lib/apt/lists/*

COPY conf/config.sh /config.sh

RUN chmod +x /config.sh

EXPOSE 9000

CMD ["/config.sh"]
