FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y \
&& apt-get install --no-install-recommends -y mariadb-server \
&& apt-get clean && rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/init_db.sh /init_db.sh

RUN chmod +x /init_db.sh && mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld

EXPOSE 3306

CMD ["/init_db.sh"]
