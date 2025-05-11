{ config, lib, ... }:
{
  systemd.network.enable = true;
  services.resolved.enable = false;

  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  systemd.network.networks.default =  {
    DHCP = "yes";
    matchConfig.Name = "eth0";
    networkConfig.IPv4Forwarding = lib.optionalAttrs config.utils.netns.enable "yes";
  };
}
