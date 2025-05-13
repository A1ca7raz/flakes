{ variables, ... }:
let
  inherit (variables.services.ns)
    cidr
  ;
in {
  utils.netns.veth.knot = {
    bridge = "global";
    netns = "knot";
    ipAddrs = cidr;
  };

  systemd.services.knot = {
    after = [ "netns-veth-knot.service" ];
    bindsTo = [ "netns-veth-knot.service" ];
    serviceConfig.NetworkNamespacePath = "/run/netns/knot";

    # # FIXME:
    # # error: config, failed to create temporary directory (unknown system error)
    # # critical: failed to open configuration database '' (not enough memory)
    # unitConfig.JoinsNamespaceOf = [ "netns@knot.service" ];
    # serviceConfig.BindReadOnlyPaths = [ "/etc/netns/knot/resolv.conf:/etc/resolv.conf" ];
    # serviceConfig.PrivateNetwork = true;
  };

  services.knot.settings.server = {
    listen = [
      "0.0.0.0"
      "::"
    ];
    # listen-quic = listenIPs;
  };
}
