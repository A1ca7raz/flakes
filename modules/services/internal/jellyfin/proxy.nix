{ variables, ... }:
let
  inherit (variables.services.media)
    ip
    domain
  ;
in {
  systemd.services.jellyfin = {
    after = [ "netns-veth-proxyh.service" ];
    bindsTo = [ "netns-veth-proxyh.service" ];
    serviceConfig.NetworkNamespacePath = [ "/run/netns/proxy" ];
  };

  services.caddy.virtualHosts.jellyfin = {
    hostName = domain;
    listenAddresses = [ ip ];
    serverAliases = [];

    extraConfig = ''
      reverse_proxy http://127.0.0.1:8096 {
        header_up X-Real-IP {remote}
        header_up Host {host}
      }
    '';
  };
}
