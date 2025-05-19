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

  utils.netns.veth.flood = {
    bridge = "homelab";
    netns = "proxy";
    addDefaultRoute = false;
  };

  systemd.services.flood = {
    after = [ "netns-veth-flood.service" ];
    bindsTo = [ "netns-veth-flood.service" ];
    serviceConfig.NetworkNamespacePath = [ "/run/netns/proxy" ];
  };

  systemd.services.caddy = {
    after = [ "netns-veth-flood.service" ];
    bindsTo = [ "netns-veth-flood.service" ];
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
