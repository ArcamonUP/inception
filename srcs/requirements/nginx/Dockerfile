FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install nginx -y && apt install openssl -y

COPY conf/start.sh start.sh

RUN chmod +x start.sh

EXPOSE 80 443

CMD ["./start.sh"]