{ config, lib, variables, ... }:
let
  vethServices = [
    "netns-veth-proxyg.service"
    "netns-veth-proxyh.service"
  ];
in {
  services.caddy = {
    enable = true;
    acmeCA = variables.misc.acme-endpoint;
  };

  # Reverse proxy netns
  utils.netns.veth.proxyg = {
    bridge = "global";
    netns = "proxy";
    ipAddrs = [
      variables.services.caddy.cidr
    ];
    addDefaultRoute = false;
  };

  utils.netns.veth.proxyh = {
    bridge = "homelab";
    netns = "proxy";
    ipAddrs = [
      variables.services.caddy2.cidr
    ];
  };

  environment.etc.netns-proxy-resolv = {
    target = "netns/proxy/resolv.conf";
    text = ''
      nameserver 192.168.1.1
    '';
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
