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

  outputs = { self, nixpkgs, nixpkgs-darwin, flake-compat, flake-parts, napalm
    , zitiConsole, }:
    flake-parts.lib.mkFlake { inherit self; } {
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      perSystem = { inputs', pkgs, system, ... }:
        let
          inherit (pkgs.lib) pipe recursiveUpdate;
          inherit (zitiVersions) state;

          zitiLib = (import lib/lib.nix) pkgs;
          zitiVersions = (import ./versions.nix) pkgs;
        in with pkgs; rec {
          devShells.default = mkShell {
            buildInputs = with packages; [
              alejandra
              shfmt
              treefmt
              ziti-edge-tunnel_latest
              ziti_latest
              ziti-tunnel_latest
            ];
          };

          legacyPackages = packages;

          packages = with zitiLib;
            pipe { } [
              (recursiveUpdate (mkZitiPkgs state))
              (recursiveUpdate (mkZitiBinTypePkgs state "tunnel"))
              (recursiveUpdate (mkZitiCliFnPkgs state))
              (recursiveUpdate (mkZitiConsole inputs' self))
              (recursiveUpdate (mkZitiEdgeTunnelPkgs state system))
              (recursiveUpdate { default = packages.ziti-edge-tunnel_latest; })
            ];
        };

      flake = {
        nixosModules = {
          ziti-controller = import ./modules/ziti-controller.nix self;
          ziti-console = import ./modules/ziti-console.nix self;
          ziti-edge-tunnel = import ./modules/ziti-edge-tunnel.nix self;
          ziti-router = import ./modules/ziti-router.nix self;
        };
      };
    };
}
