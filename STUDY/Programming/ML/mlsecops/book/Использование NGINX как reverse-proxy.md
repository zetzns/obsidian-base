> [!security]
> Конфигурация позволяет:
> 1. перенаправлять HTTP → HTTPS;
> 2. предоставлять публичный статус для service_app и service_api;
> 3. запрещать прямой доступ к service_api;
> 4. применять rate limiting «1 запрос/сек»;
> 5. отдавать основной трафик в web-app.

Кусок из nginx.conf:

```nginx
server {
    listen 80;
    location / {
        return 301 https://$host$request_uri;
    }
}
server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/service_cert.pem;
    ssl_certificate_key /etc/nginx/ssl/service_key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;

    location /status/app { proxy_pass http://service_app/heartbeat; }
    location /status/api { proxy_pass http://service_api/heartbeat; }

    location ~ ^/(?!status/api).*$ { deny all; }

    location / {
        proxy_pass http://service_app;
        limit_req zone=one burst=5;
    }
}
limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
```

В Docker Compose подключают конфиг и сертификаты:

```nginx
services:
  proxy:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./proxy/nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - service_app
```