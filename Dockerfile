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
    && CGO_ENABLED=0 GOOS=linux go run build.go 

FROM alpine:latest
LABEL maintainer="ulrich.schreiner@gmail.com"

RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/mholt/caddy/caddy/caddy  .
ENTRYPOINT ["/root/caddy"]  
