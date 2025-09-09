FROM debian:13


ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get install -y openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]