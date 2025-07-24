[macos]
build:
  podman run -v ./:/app -w /app --rm --platform linux/arm64 nixos/nix:latest bash -c ' \
      nix --extra-experimental-features nix-command --extra-experimental-features flakes build && \
      cp -L ./result ./build.tar.gz'
  podman load < build.tar.gz
  rm -f build.tar.gz

[linux]
build:
  nix build

run:
  podman run --rm -p 80:80 scarey-web
