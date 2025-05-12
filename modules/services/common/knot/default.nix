{ lib, pkgs, zones, ... }:
let
  inherit (lib)
    singleton
  ;
in {
  imports = [
    ./netns.nix
  ];

  services.knot = {
    enable = true;

    settings = {
      server = {
        async-start = true;
        edns-client-subnet = true;
        tcp-fastopen = true;
        tcp-reuseport = true;
        automatic-acl = true;

        # # Certificate for DoQ/DoT
        # key-file = config.sops.secrets."quic/key".path;
        # cert-file = config.sops.secrets."quic/cert".path;
      };

      log = singleton {
        target = "syslog";
        any = "info";
      };

      policy = singleton {
        algorithm = "ed25519";
        id = "default";
        nsec3 = true;
        nsec3-iterations = 0;
        nsec3-salt-length = 0;
        signing-threads = 4;
      };

      template = singleton {
        id = "default";
        dnssec-policy = "default";
        dnssec-signing = true;
        journal-content = "all";
        semantic-checks = true;
        serial-policy = "unixtime";
        zonefile-load = "difference-no-serial";
        zonefile-sync = "-1";
        zonemd-generate = "zonemd-sha512";
      };

      zone = [
        {
          domain = "home";
          file = pkgs.writeText "zones.home" zones.homelab;
        }
        {
          domain = "insyder";
          file = pkgs.writeText "zones.insyder" zones.private;
        }
      ];
    };
  };
}
