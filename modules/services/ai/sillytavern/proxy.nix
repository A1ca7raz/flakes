{ variables, ... }:
let
  inherit (variables.services.sillytavern)
    ip
    domain
  ;
in {
  systemd.services.sillytavern = {
    after = [ "netns-veth-proxyh.service" ];
    bindsTo = [ "netns-veth-proxyh.service" ];
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
