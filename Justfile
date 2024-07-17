build:
  podman build -t scarey-web .

run:
  podman run --rm -p 80:80 -p 443:443 -e SITE=localhost scarey-web
