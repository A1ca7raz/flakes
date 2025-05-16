{ variables, ... }:
let
  inherit (variables.services.media)
    ip
    domain
  ;
in {
  utils.netns.veth.jellyfin = {
    bridge = "homelab";
    netns = "proxy";
    addDefaultRoute = false;
  };

  systemd.services.caddy = {
    after = [ "netns-veth-jellyfin.service" ];
    bindsTo = [ "netns-veth-jellyfin.service" ];
  };

  systemd.services.jellyfin = {
    after = [ "netns-veth-jellyfin.service" ];
    bindsTo = [ "netns-veth-jellyfin.service" ];
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
