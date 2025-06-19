FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt-get install mariadb-server -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/init_db.sh init_db.sh

RUN chmod +x init_db.sh
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld

CMD ["./init_db.sh"]
