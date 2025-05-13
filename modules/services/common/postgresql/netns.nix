{ lib, config, variables, ... }:
let
  inherit (lib)
    optionalAttrs
    optionalString
    mkForce
  ;

  inherit (variables.services.postgresql)
    ip
    cidr
  ;

  cfg = config.utils.netns.enable;

  localIPs = [ "127.0.0.1" "::1" ];

  remoteIPs = [ ip ];
in {
  utils.netns.veth.psql = {
    bridge = "global";
    netns = "psql";
    ipAddrs = cidr;
  };

  systemd.services.postgresql = optionalAttrs cfg {
    after = [ "netns-veth-psql.service" ];
    bindsTo = [ "netns-veth-psql.service" ];
    unitConfig.JoinsNamespaceOf = [ "netns@psql.service" ];
    # Alternatively: serviceConfig.NetworkNamespacePath = "/var/run/netns/${netns}";
    serviceConfig.BindReadOnlyPaths = [ "/etc/netns/psql/resolv.conf:/etc/resolv.conf" ];
    serviceConfig.PrivateNetwork = true;
  };

  services.postgresql = {
    settings.listen_addresses = mkForce (
      builtins.concatStringsSep
      ", "
      (localIPs ++ remoteIPs)
    );

    # Allow access from private wired network
    authentication = optionalString cfg ''
      host all all 192.168.0.0/16 md5
    '';
  };
}
