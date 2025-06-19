FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends -y curl php-mysql php-fpm && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY conf/config.sh config.sh

RUN chmod +x config.sh

CMD ["./config.sh"]
