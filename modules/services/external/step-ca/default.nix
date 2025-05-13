{ pkgs, variables, config, secrets, ... }:
let
  inherit (variables.services.pki.x1) domain;
in {
  imports = [
    ./netns.nix
  ];

  utils.secrets."x1/private_key".path = secrets.services.pki.x1;

  services.step-ca = {
    enable = true;

    settings = {
      root = ../../../system/security/r1.crt;
      key = config.sops.secrets."x1/private_key".path;
      address = ":443";
      dnsNames = [ domain ];

      db = {
        type = "badgerV2";
        dataSource = "db";
        valueDir = "valuedb";
      };

      crl = {
        enabled = true;
        generateOnRevoke = true;
      };

      authority = {
        disableIssuedAtCheck = false;
        claims = {
          minTLSCertDuration = "24h";
          maxTLSCertDuration = "720d";
          defaultTLSCertDuration = "360d";
          disableRenewal = false;
          allowRenewalAfterExpiry = false;
        };
        policy.x509 = {
          allow.dns = [
            "*.insyder"
            "*.home"
          ];
          allow.ip = [
            "198.18.0.0/15"
            "192.168.0.0/16"
          ];
          allowWildcardNames = true;
        };
        provisioners = [
          {
            type = "ACME";
            name = "x1";
            forceCN = true;
            termsOfService = "http://${domain}/tos";
            website = "http://${domain}";
            challenges = [
              "http-01"
              "dns-01"
              "tls-alpn-01"
            ];
          }
        ];
      };
    };
  };

  environment.systemPackages = [ pkgs.step-cli ];
}
