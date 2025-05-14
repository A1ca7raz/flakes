{ pkgs, variables, config, secrets, ... }:
let
  inherit (variables.services.pki.x1) domain;
in {
  imports = [
    ./netns.nix
  ];

  utils.secrets."x1/private_key".path = secrets.services.pki.x1;
  utils.secrets."x1/password".path = secrets.services.pki.x1;
  utils.secrets."x1/leaf_tpl".path = secrets.services.pki.x1;
  sops.secrets."x1/private_key" = {
    owner = "step-ca";
    group = "step-ca";
  };
  sops.secrets."x1/leaf_tpl" = {
    owner = "step-ca";
    group = "step-ca";
  };

  services.step-ca = {
    enable = true;
    address = "";
    port = 443;
    intermediatePasswordFile = config.sops.secrets."x1/password".path;

    settings = {
      root = ../../../system/security/r1.crt;
      key = config.sops.secrets."x1/private_key".path;
      crt = ./x1.crt;

      # address = ":443";
      dnsNames = [ domain ];

      db = {
        type = "badgerV2";
        dataSource = "/var/lib/step-ca/db";
        valueDir = "/var/lib/step-ca/valuedb";
      };

      crl = {
        enabled = true;
        generateOnRevoke = true;
      };

      authority = {
        claims = {
          minTLSCertDuration = "24h";
          maxTLSCertDuration = "17280h";    # 720 days
          defaultTLSCertDuration = "8640h";  # 360 days
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
            website = "http://${domain}";
            challenges = [
              "http-01"
              "dns-01"
              "tls-alpn-01"
            ];
            options.x509.templateFile = config.sops.secrets."x1/leaf_tpl".path;   # Add CRL endpoint
          }
        ];
      };
      # tls = {
      #   cipherSuites = [
      #     "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
      #     "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
      #   ];
      #   minVersion = 1.2;
      #   maxVersion = 1.3;
      #   renegotiation = false;
      # };
    };
  };

  environment.systemPackages = [ pkgs.step-cli ];
}
