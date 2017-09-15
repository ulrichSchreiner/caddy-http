FROM ulrichschreiner/caddy-builder:0.10.9 as builder
LABEL maintainer="ulrich.schreiner@gmail.com"

FROM caddy-runtime:0.10.9
LABEL maintainer="ulrich.schreiner@gmail.com"

COPY --from=builder /go/src/github.com/mholt/caddy/caddy/caddy /usr/bin/
USER caddy
