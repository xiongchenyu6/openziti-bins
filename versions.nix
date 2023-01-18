pkgs: let
  inherit (pkgs.lib) fakeSha256;
in {
  state = {
    srcZiti = rec {
      latest = let l = v0-27-2; in {inherit (l) version hash;};

      v0-27-2 = {
        version = "0.27.2";
        hash = "sha256-3Fo2PoyibmT/pSALIN6gM4kSSv8kKgTzeNKa/vGI5gc=";
      };

      v0-26-10 = {
        version = "0.26.10";
        hash = "sha256-+16ufjL6ej4lGkRsA6wNBN4s8EeQc2utzEGBIJ0ijls=";
      };

      v0-26-9 = {
        version = "0.26.9";
        hash = "sha256-cp07b5MyzK6109l7lB11bBa2+sXzGwqC2QJExuSwL5k=";
      };

      v0-26-8 = {
        version = "0.26.8";
        hash = "sha256-wmHpL9TaytEnyFZ7FuDffUD4VwRUkQigJS++BiP1fZo=";
      };
    };

    srcBinZiti = rec {
      latest = let l = v0-27-2; in {inherit (l) version hash;};

      v0-27-2 = {
        version = "0.27.2";
        hash = "sha256-BsEsRuNEdMWrMTkokRHVrq9SjGsxw2aclrsVvxF595A=";
      };

      v0-26-10 = {
        version = "0.26.10";
        hash = "sha256-kIJak44wjWi6iLyKdiSifNhZSZmjyNrcLCx/ggVQArE=";
      };

      v0-26-9 = {
        version = "0.26.9";
        hash = "sha256-QA/ks618eI+yJH+sBJyygORq5bCLeVefq3m9xo11Pf4=";
      };

      v0-26-8 = {
        version = "0.26.8";
        hash = "sha256-OovvwJ6cwiktccqkPdTXy8IvS4EdYLrIxqnB8Dz2sWM=";
      };
    };

    srcBinZitiEdgeTunnel = rec {
      latest = let l = v0-20-18; in {inherit (l) version hash;};

      v0-20-18 = {
        version = "0.20.18";
        hash = "sha256-D773ZeEs/NUp/lwVCKxYz5voq/MXeLiJU5YcB/Vcs8g=";
      };

      v0-20-6 = {
        version = "0.20.6";
        hash = "sha256-fyOJJ88DvRCVHNtlWt1eUJdH1XRAyeSgHeJTwxWM8e0=";
      };

      v0-20-2 = {
        version = "0.20.2";
        hash = "sha256-ZgeVSGqy12CQJEErzQ1gaXtJbv5bVncH66Li1X8D3P0=";
      };

      v0-20-0 = {
        version = "0.20.0";
        hash = "sha256-/AS8PUaBjfunEwXvWnVmwMQSdQ0CHYM+FpbCSploaeA=";
      };

      v0-19-11 = {
        version = "0.19.11";
        hash = "sha256-cZne4M7XZV+bpOq5moRexMqhKCkBQ8pMpa7A7oBOcX8=";
      };
    };
  };
}
