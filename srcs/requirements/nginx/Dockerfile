FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y \
&& apt-get install --no-install-recommends -y nginx openssl \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY conf/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 443

CMD ["/start.sh"]
