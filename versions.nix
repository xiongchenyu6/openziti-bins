pkgs:
let inherit (pkgs.lib) fakeSha256;
in {
  state = {
    srcZiti = rec {
      latest = v0-33-1;
      v0-33-1 = {
        version = "0.33.1";
        hash = "sha256-U7A7n+SVIONx16tC4ITtQUVj7GF9sEi/tceaBojO3KM=";
      };
    };

    srcBinZiti = rec {
      latest = v0-33-1;
      v0-33-1 = {
        version = "0.33.1";
        hash = "sha256-a3qeXafmefte6kzpEiDtI10r/1CD7OLbV1M+0xX3BWY=";
      };
    };

    srcBinZitiEdgeTunnel = let
    in rec {
      x86_64-linux = rec {
        latest = v0-22-25;
        v0-22-25 = {
          version = "0.22.25";
          hash = "sha256-Ad2TXkZYLuCtgqlbUxS/1CK8ImTbDHvulSg+irpV9rc=";
        };
      };

      x86_64-darwin = rec {
        latest = v0-22-25;
        v0-22-25 = {
          version = "0.22.25";
          hash = "sha256-Ad2TXkZYLuCtgqlbUxS/1CK8ImTbDHvulSg+irpV9rc=";
        };
      };

      aarch64-darwin = rec {
        latest = v0-22-25;
        v0-22-25 = {
          version = "0.22.25";
          hash = "sha256-Ad2TXkZYLuCtgqlbUxS/1CK8ImTbDHvulSg+irpV9rc=";
        };
      };
    };
  };
}
