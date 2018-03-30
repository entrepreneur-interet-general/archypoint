FROM nginx:1.13.9 as dev

RUN apt-get update && apt-get install \
  openssl=1.1.0f-3+deb9u1

WORKDIR /run/secrets/

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/CN=localhost" \
  -keyout ./privkey.pem \
  -out ./cert.pem

RUN cp cert.pem fullchain.pem

WORKDIR /etc/nginx/conf.d

RUN rm -fr ./*

COPY nginx.conf .

ARG domain
RUN sed -i -e 's/${domain}/'$domain'/g' nginx.conf

ARG www_pass
RUN sed -i -e 's/${www_pass}/'$www_pass'/g' nginx.conf

ARG api_pass
RUN sed -i -e 's/${api_pass}/'$api_pass'/g' nginx.conf

FROM nginx:1.13.9-alpine as prod

WORKDIR /etc/nginx/conf.d
RUN rm -fr ./*
COPY --from=dev /etc/nginx/conf.d/nginx.conf .
