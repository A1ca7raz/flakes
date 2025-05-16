{ lib, ... }:
{
  imports = [
    ./proxy.nix
  ];

  services.jellyfin = {
    enable = true;
    logDir = "/var/log/jellyfin";
  };

  systemd.tmpfiles.settings.jellyfinDirs = lib.mkForce {};

  # Shared group with media downloaders
  users.users.jellyfin.extraGroups = [ "media" ];
  users.groups.media = {};

  # Create service directories by systemd
  systemd.services.jellyfin.serviceConfig = {
    StateDirectory = "jellyfin";
    LogsDirectory = "jellyfin";
    CacheDirectory = "jellyfin";
  };
}
