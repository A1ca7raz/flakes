{ config, lib, variables, ... }:
let
  vethServices = [
    "netns-veth-caddy1.service"
    "netns-veth-caddy2.service"
  ];
in {
  services.caddy = {
    enable = true;
    acmeCA = variables.misc.acme-endpoint;
  };

  # Reverse proxy netns
  utils.netns.veth.caddy1 = {
    bridge = "global";
    netns = "proxy";
    ipAddrs = [
      variables.services.caddy.cidr
    ];
    addDefaultRoute = false;
  };

  utils.netns.veth.caddy2 = {
    bridge = "homelab";
    netns = "proxy";
    ipAddrs = [
      variables.services.caddy2.cidr
    ];
  };

  systemd.services.caddy = lib.mkIf config.utils.netns.enable {
    after = vethServices;
    bindsTo = vethServices;

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
