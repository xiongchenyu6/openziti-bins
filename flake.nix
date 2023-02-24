{
  description = "OpenZiti patched binaries";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    napalm = {
      url = "github:nix-community/napalm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zitiConsole = {
      url = "github:openziti/ziti-console";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-darwin,
    flake-compat,
    flake-parts,
    napalm,
    zitiConsole,
  }:
    flake-parts.lib.mkFlake {inherit self;} {
      systems = ["x86_64-linux"];
      perSystem = {
        inputs',
        pkgs,
        system,
        ...
      }: let
        inherit (pkgs.lib) pipe recursiveUpdate;
        inherit (zitiVersions) state;

        zitiLib = (import lib/lib.nix) pkgs;
        zitiVersions = (import ./versions.nix) pkgs;
      in
        with pkgs; rec {
          devShells.default = mkShell {
            buildInputs = with packages; [
              alejandra
              shfmt
              treefmt
              ziti-cli-functions_latest
              ziti-controller_latest
              ziti-edge-tunnel_latest
              ziti_latest
              ziti-router_latest
              ziti-tunnel_latest
            ];
          };

          legacyPackages = packages;

          packages = with zitiLib;
            pipe {} [
              (recursiveUpdate (mkZitiPkgs state))
              (recursiveUpdate (mkZitiBinTypePkgs state "controller"))
              (recursiveUpdate (mkZitiBinTypePkgs state "router"))
              (recursiveUpdate (mkZitiBinTypePkgs state "tunnel"))
              (recursiveUpdate (mkZitiCliFnPkgs state))
              (recursiveUpdate (mkZitiConsole inputs' self))
              (recursiveUpdate (mkZitiEdgeTunnelPkgs state))
              (recursiveUpdate {default = packages.ziti-edge-tunnel_latest;})
            ];
        };

      flake = {
        packages.x86_64-darwin.ziti-edge-tunnel_latest = with nixpkgs-darwin.legacyPackages.x86_64-darwin; stdenv.mkDerivation rec {
          version = "0.20.20";
          name = "ziti-edge-tunnel_${version}";

          src = fetchzip {
            sha256 = "sha256-6CU3U2wuQNTaOBVDHIVbXgg1dtRJ65lrHqDewVkQTBk=";
            url = "https://github.com/openziti/ziti-tunnel-sdk-c/releases/download/v${version}/ziti-edge-tunnel-Darwin_x86_64.zip";
          };

          sourceRoot = ".";

          installPhase = ''
            install -m755 -D source/ziti-edge-tunnel $out/bin/ziti-edge-tunnel
          '';

          meta = {
            homepage = "https://github.com/openziti/ziti-tunnel-sdk-c";
            description = "Ziti: programmable network overlay and associated edge components for application-embedded, zero-trust networking";
            license = lib.licenses.asl20;
            platforms = ["x86_64-darwin"];
          };
        };

        packages.aarch64-darwin.ziti-edge-tunnel_latest = with nixpkgs-darwin.legacyPackages.aarch64-darwin; stdenv.mkDerivation rec {
          version = "unstable";
          name = "ziti-edge-tunnel_${version}";

          buildInputs = [unzip];
          src = ./zip/ziti-edge-tunnel-Darwin_arm64.zip;

          sourceRoot = ".";

          installPhase = ''
            install -m755 -D ziti-edge-tunnel $out/bin/ziti-edge-tunnel
          '';

          meta = {
            homepage = "https://github.com/openziti/ziti-tunnel-sdk-c";
            description = "Ziti: programmable network overlay and associated edge components for application-embedded, zero-trust networking";
            license = lib.licenses.asl20;
            platforms = ["aarch64-darwin"];
          };
        };

        # darwinModules;
        nixosModules = {
          ziti-controller = import ./modules/ziti-controller.nix self;
          ziti-console = import ./modules/ziti-console.nix self;
          ziti-edge-tunnel = import ./modules/ziti-edge-tunnel.nix self;
          ziti-router = import ./modules/ziti-router.nix self;
        };
      };
    };
}
