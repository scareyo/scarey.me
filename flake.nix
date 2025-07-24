{
  description = "scarey.me devshell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      perSystem = { config, pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            just
            podman
            qemu
          ];
        };
        packages.default = let 
          site = pkgs.runCommand "static-site" {} ''
            mkdir -p $out
            cp -r ${./site}/* $out/
          '';
        in pkgs.dockerTools.buildLayeredImage {
          name = "ghcr.io/scareyo/web";
          tag = "latest";

          contents = [
            pkgs.busybox
            site
          ];

          config = {
            Cmd = [ "${pkgs.busybox}/bin/httpd" "-f" "-p" "80" "-h" "${site}" ];
            ExposedPorts = { "80/tcp" = {}; };
          };
        };
      };
    };
}
