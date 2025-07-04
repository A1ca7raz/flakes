{ lib, pkgs, ... }:
{
  imports = [
    ./proxy.nix
  ];

  services.jellyfin = {
    enable = true;
    logDir = "/var/log/jellyfin";
    group = "media";
  };

  systemd.tmpfiles.settings.jellyfinDirs = lib.mkForce {};

  # Shared group with media downloaders
  users.groups.media.gid = 900;

  # Create service directories by systemd
  systemd.services.jellyfin.serviceConfig = {
    UMask = lib.mkForce "0002";
    StateDirectory = "jellyfin";
    LogsDirectory = "jellyfin";
    CacheDirectory = "jellyfin";
  };

  fonts.packages = [
    pkgs.noto-fonts-cjk-sans
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Noto Sans CJK SC" ];
  };
}
