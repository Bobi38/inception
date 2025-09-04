FROM debian:13

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade && \
    apt-get install -y wget && \
    apt-get install -y git && \
    apt-get install -y tar



run apt-get install apt-transport-https && \
    mkdir -p /etc/apt/keyrings && \
    wget -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp' && \
    apt-get install mariadb-server -y

RUN rm /etc/mysql/my.cnf

CMD ["mariadb"]
