FROM debian:13


ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get install -y openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/nginx-selfsigned.key \
    -out /etc/nginx/certs/nginx-selfsigned.crt \
    -subj "/C=FR/ST=State/L=City/O=Organization/CN=localhost"

COPY default.conf /etc/nginx/conf.d/default.conf



EXPOSE 80 443


CMD ["nginx", "-g", "daemon off;"]