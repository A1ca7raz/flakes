{ variables, config, lib, ... }:
let
  inherit (variables.services.gallery)
    ip
    domain
  ;

  netnsConfig = {
    bindsTo = [ "netns-veth-proxyh.service" ];
    requires = [
      "redis-immich.service"
    ];
    after = [
      "postgresql.service"
      "redis-immich.service"
      "netns-veth-proxyh.service"
    ];

    serviceConfig.NetworkNamespacePath = [ "/run/netns/proxy" ];
    # unitConfig.JoinsNamespaceOf = [ "netns@proxy.service" ];
    # serviceConfig = {
    #   PrivateNetwork = true;
    #   PrivateMounts = false;
    # };
  };
in {
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
