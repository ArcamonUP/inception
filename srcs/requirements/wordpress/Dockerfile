FROM debian:buster

RUN apt update -y && apt upgrade -y && apt-get install curl -y && apt-get install php-mysql php-fpm -y

COPY conf/config.sh config.sh

RUN chmod +x config.sh

CMD ["./config.sh"]
