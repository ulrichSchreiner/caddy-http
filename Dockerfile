FROM ulrichschreiner/caddy-builder:0.10.9 as builder
LABEL maintainer="ulrich.schreiner@gmail.com"

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
