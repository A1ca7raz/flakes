{ config, lib, ... }:
{
  systemd.network.enable = true;
  services.resolved.enable = true;  # Required by DNS from DHCP
  networking.resolvconf.enable = false;

  systemd.network.networks.default =  {
    DHCP = "yes";
    matchConfig.Name = "eth0";
    networkConfig.IPv4Forwarding = lib.optionalAttrs config.utils.netns.enable "yes";
  };
}
