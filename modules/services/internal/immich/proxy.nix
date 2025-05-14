{ variables, config, lib, ... }:
let
  inherit (variables.services.gallery)
    ip
    domain
  ;

  netnsConfig = {
    bindsTo = [ "netns-veth-immich.service" ];
    requires = [
      "redis-immich.service"
    ];
    after = [
      "postgresql.service"
      "redis-immich.service"
      "netns-veth-immich.service"
    ];

    serviceConfig.NetworkNamespacePath = [ "/run/netns/proxy" ];
    # unitConfig.JoinsNamespaceOf = [ "netns@proxy.service" ];
    # serviceConfig = {
    #   PrivateNetwork = true;
    #   PrivateMounts = false;
    # };
  };
in {
  utils.netns.veth.immich = {
    bridge = "homelab";
    netns = "proxy";
    addDefaultRoute = false;
  };

  systemd.services.caddy = {
    after = [ "netns-veth-immich.service" ];
    bindsTo = [ "netns-veth-immich.service" ];
  };

  systemd.services.immich-server = netnsConfig;
  systemd.services.immich-machine-learning = lib.mkIf config.services.immich.machine-learning.enable netnsConfig;

  services.caddy.virtualHosts.immich = {
    hostName = domain;
    listenAddresses = [ ip ];
    serverAliases = [];

    extraConfig = ''
      reverse_proxy http://127.100.0.1:2283 {
        header_up X-Real-IP {remote}
        header_up Host {host}
      }
    '';
  };
}
