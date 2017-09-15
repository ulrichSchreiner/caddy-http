FROM ulrichschreiner/caddy-builder:0.10.9 as builder
FROM caddy-runtime:0.10.9
COPY --from=builder /go/src/github.com/mholt/caddy/caddy/caddy /usr/bin/
USER caddy
