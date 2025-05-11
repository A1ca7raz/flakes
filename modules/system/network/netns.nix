{ lib, ... }:
{
  utils.netns.enable = true;
  utils.netns.bridge."0".ipAddrs = lib.mkDefault [ "10.0.0.254/24" ];

  # https://lantian.pub/article/modify-website/dn42-experimental-network-2020.lantian/#%E9%9D%9E%E5%B8%B8%E9%87%8D%E8%A6%81%E7%9A%84%E7%B3%BB%E7%BB%9F%E9%85%8D%E7%BD%AE
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.default.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.default.rp_filter" = 0;
    "net.ipv4.conf.all.rp_filter" = 0;
  };
}
