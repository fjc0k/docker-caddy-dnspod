#
# Builder
#
FROM golang:1.13-alpine as builder

RUN apk add --no-cache git gcc musl-dev

COPY builder.sh /usr/bin/builder.sh

ARG version="v1"
ARG plugins="cache,cors,expires,realip,ipfilter,dnspod"
ARG enable_telemetry="false"

# process wrapper
RUN go get -v github.com/abiosoft/parent

RUN VERSION=${version} PLUGINS=${plugins} ENABLE_TELEMETRY=${enable_telemetry} /bin/sh /usr/bin/builder.sh

#
# Final stage
#
FROM alpine:3.10
LABEL maintainer "Jay Fong <fjc0kb@gmail.com>"

ENV CADDY_VERSION=1.0.5

# 证书申请人邮箱
ENV APPLICANT_EMAIL=""

# 证书存放路径
ENV CADDYPATH=/caddy/certs

RUN apk add --no-cache \
  ca-certificates \
  git \
  mailcap \
  openssh-client \
  tzdata

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443 2015
WORKDIR /srv

COPY Caddyfile /caddy/Caddyfile
COPY index.html /srv/index.html
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

# install process wrapper
COPY --from=builder /go/bin/parent /bin/parent

ENTRYPOINT ["./entrypoint.sh"]
CMD ["-conf", "/caddy/Caddyfile", "-log", "stdout", "-agree"]
