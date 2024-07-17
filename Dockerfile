FROM caddy:2
ENV SITE="scarey.me"
COPY Caddyfile /etc/caddy/Caddyfile
COPY site /srv
