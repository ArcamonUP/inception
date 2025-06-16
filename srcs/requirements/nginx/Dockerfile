FROM debian:buster

RUN apt update && apt upgrade -y && apt install nginx -y && apt install openssl

COPY conf/start.sh start.sh

RUN chmod +x start.sh

CMD ["./start.sh"]