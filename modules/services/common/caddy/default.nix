{ config, lib, variables, ... }:
{
  services.caddy = {
    enable = true;
    acmeCA = variables.misc.acme-endpoint;
  };

  # Reverse proxy netns
  utils.netns.veth.caddy = {
    bridge = "global";
    netns = "proxy";
    ipAddrs = variables.services.caddy.cidr;
  };

  systemd.services.caddy = lib.mkIf config.utils.netns.enable {
    after = [ "netns-veth-caddy.service" ];
    bindsTo = [ "netns-veth-caddy.service" ];

    unitConfig.JoinsNamespaceOf = [ "netns@proxy.service" ];
    serviceConfig = {
      BindReadOnlyPaths = [ "/etc/netns/proxy/resolv.conf:/etc/resolv.conf" ];
      PrivateNetwork = true;

      # Light-weight Harden
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      LimitNOFILE = 1048576;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectProc = "invisible";
      RemoveIPC = true;
      ProtectControlGroups = true;
      ProtectKernelTunables = true;
    };
  };
}
