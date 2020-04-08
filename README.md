# docker-caddy-dnspod

在 [Docker](https://www.docker.com/) 中运行 [Caddy 1](https://caddyserver.com/v1/)。

## 内置插件

- [http.cache](https://caddyserver.com/v1/docs/http.cache)
- [http.cors](https://caddyserver.com/v1/docs/http.cors)
- [http.expires](https://caddyserver.com/v1/docs/http.expires)
- [http.realip](https://caddyserver.com/v1/docs/http.realip)
- [http.ipfilter](https://caddyserver.com/v1/docs/http.ipfilter)
- [http.forwardproxy](https://caddyserver.com/v1/docs/http.forwardproxy)
- [http.webdav](https://caddyserver.com/v1/docs/http.webdav)
- [tls.dns.dnspod](https://caddyserver.com/v1/docs/tls.dns.dnspod)

## 使用

### 尝试一下

运行以下命令：

```bash
docker run \
  --rm \
  --publish 2015:2015 \
  jayfong/caddy-dnspod
```

然后浏览器打开 `http://localhost:2015` 查看成果。

### 更符合实际的示例

该示例是一个 `docker-compose.yml`：

```yaml
version: '3'

services:
  caddy:
    image: jayfong/caddy-dnspod
    environment:
      # 时区
      - TZ=Asia/Shanghai
      # 申请 SSL 证书时使用的邮箱
      - APPLICANT_EMAIL=ok@hello.caddy
      # dnspod 的鉴权信息，格式：ID,Token
      - DNSPOD_API_KEY=***,**************
    volumes:
      # 项目的 Caddyfile
      - ./Caddyfile:/caddy/Caddyfile
      # Caddy 自动生成的 SSL 证书
      - ./data/certs:/caddy/certs
    ports:
      - 2015:2015
      - 80:80
      - 443:443
    restart: unless-stopped
```

了解 `Caddyfile` 的语法请访问其官网：[https://caddyserver.com/docs/caddyfile](https://caddyserver.com/docs/caddyfile)。

> **在 `Caddyfile` 里可以使用 `dockerhost` 指向宿主机。** 

## 参考

- [abiosoft/caddy-docker](https://github.com/abiosoft/caddy-docker)

## 许可

Jay Fong © MIT
