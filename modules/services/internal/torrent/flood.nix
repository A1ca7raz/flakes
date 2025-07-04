{ variables, ... }:
let
  inherit (variables.services.flood)
    ip
    domain
  ;
in {
  services.flood = {
    enable = true;
    host = "127.120.100.2";
    port = 8081;

    extraArgs = [
      "--auth None"
    ];
  };

  systemd.services.flood = {
    after = [ "netns-veth-proxyh.service" ];
    bindsTo = [ "netns-veth-proxyh.service" ];
    serviceConfig.NetworkNamespacePath = [ "/run/netns/proxy" ];
  };

  services.caddy.virtualHosts.flood = {
    hostName = domain;
    listenAddresses = [ ip ];
    serverAliases = [];

    extraConfig = ''
      reverse_proxy http://127.120.100.2:8081 {
        header_up X-Real-IP {remote}
        header_up Host {host}
      }
    '';
  };
}
