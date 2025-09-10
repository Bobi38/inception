FROM debian:13

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    apt-get clean

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

COPY tvoisin.cnf /etc/mysql/mariadb.conf.d/

COPY go.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/go.sh

ENTRYPOINT ["/usr/local/bin/go.sh"]

CMD ["mariadbd"]

