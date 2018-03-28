FROM nginx:1.13.9 as dev

RUN apt-get update && apt-get install \
  openssl=1.1.0f-3+deb9u1

WORKDIR /etc/nginx/ssl

ENV SUBJ="/C=fr/ST=paris/L=paris/O=etalab/OU=archifiltre/CN=archifiltre.io"
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "$SUBJ" \
  -keyout ./privkey.pem \
  -out ./cert.pem

RUN cp cert.pem fullchain.pem

WORKDIR /etc/nginx/conf.d

RUN rm -fr ./*

COPY nginx.conf .

RUN sed -i -e 's/${domain}/localhost/g' nginx.conf


FROM nginx:1.13.9-alpine as prod

WORKDIR /etc/nginx/conf.d
RUN rm -fr ./*
COPY nginx.conf .
RUN sed -i -e 's/${domain}/archifiltre.io/g' nginx.conf
