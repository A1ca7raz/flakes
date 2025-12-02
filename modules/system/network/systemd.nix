{ config, lib, ... }:
let
  inherit (lib)
    optionalAttrs
    tags
  ;
in {
  systemd.network.enable = true;
  services.resolved.enable = true;  # Required by DNS from DHCP
  networking.resolvconf.enable = false;

  systemd.network.networks.default =  {
    DHCP = "yes";
    matchConfig.Name = lib.mkDefault "eth0";
    networkConfig =
      optionalAttrs config.utils.netns.enable { IPv4Forwarding = "yes"; } //
      optionalAttrs (tags ? server) { IPv6PrivacyExtensions = "no"; };
    ipv6AcceptRAConfig.Token = "eui64";
  };
}
