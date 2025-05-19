{ variables, ... }:
let
  inherit (variables.services.sillytavern)
    ip
    domain
  ;
in {
  utils.netns.veth.tavern = {
    bridge = "homelab";
    netns = "proxy";
    addDefaultRoute = false;
  };

  systemd.services.caddy = {
    after = [ "netns-veth-tavern.service" ];
    bindsTo = [ "netns-veth-tavern.service" ];
  };

  systemd.services.sillytavern = {
    after = [ "netns-veth-tavern.service" ];
    bindsTo = [ "netns-veth-tavern.service" ];
    serviceConfig = {
      NetworkNamespacePath = [ "/run/netns/proxy" ];
      BindReadOnlyPaths = [ "/etc/netns/proxy/resolv.conf:/etc/resolv.conf" ];
    };
  };

  services.caddy.virtualHosts.sillytavern = {
    hostName = domain;
    listenAddresses = [ ip ];
    serverAliases = [];

    extraConfig = ''
      reverse_proxy http://127.0.0.1:8163 {
        # FIXME: delete forward header until account system deployed
        header_up -X-Forwarded-For
        # header_up X-Real-IP {remote}
        # header_up Host {host}
      }
    '';
  };
}
