FROM golang:1.9-alpine as builder
LABEL maintainer="ulrich.schreiner@gmail.com"

RUN apk update \
    && apk add git 

ENV CADDY_VERSION v0.10.9

WORKDIR /go/src
RUN mkdir -p github.com/mholt \
    && cd github.com/mholt \
    && git clone https://github.com/mholt/caddy.git \
    && go get -u github.com/caddyserver/builds 
COPY plugins.go /go/src/github.com/mholt/caddy/caddy/caddymain/plugins.go

RUN cd github.com/mholt/caddy/caddy \
    && go get -u ./... \
    && git checkout -q ${CADDY_VERSION} \
    && go run build.go goos=linux 

FROM alpine:latest
LABEL maintainer="ulrich.schreiner@gmail.com"

RUN apk --no-cache add ca-certificates libcap && mkdir /conf
WORKDIR /srv
COPY Caddyfile /conf/Caddyfile
COPY index.html /srv/index.html

COPY --from=builder /go/src/github.com/mholt/caddy/caddy/caddy /usr/bin/
RUN addgroup -S caddy \
    && adduser -D -S -s /sbin/nologin -G caddy caddy \
    && setcap cap_net_bind_service=+ep /usr/bin/caddy \
    && chown -R caddy:caddy /srv

EXPOSE 80 443 2015
USER caddy
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/conf/Caddyfile"]
