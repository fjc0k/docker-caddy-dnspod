FROM alpine:latest

WORKDIR /caddy

ARG telemetry=off
ARG plugins=http.cache,http.cors,http.expires,http.realip,http.ipfilter,tls.dns.dnspod

ENV CADDY_VERSION=1.0.1
ENV GET_CADDY_URL="https://caddyserver.com/download/linux/amd64?plugins=${plugins}&license=personal&telemetry=${telemetry}"
# 证书申请人邮箱
ENV APPLICANT_EMAIL=""
# 证书存放路径
ENV CADDYPATH=/caddy/certs

COPY Caddyfile .
COPY index.html /srv/index.html
COPY entrypoint.sh .

RUN apk add --update --no-cache ca-certificates mailcap tzdata \
  && wget -O- ${GET_CADDY_URL} | tar --no-same-owner -C /usr/bin/ -xz caddy \
  && chmod +x /usr/bin/caddy entrypoint.sh \
  && /usr/bin/caddy -version

EXPOSE 80 443 2015

ENTRYPOINT ["./entrypoint.sh"]

CMD ["-conf", "/caddy/Caddyfile", "-log", "stdout", "-agree"]
