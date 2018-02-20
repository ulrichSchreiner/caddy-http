FROM ulrichschreiner/caddy-builder:0.10.11 as builder
FROM ulrichschreiner/caddy-runtime:latest
USER caddy
