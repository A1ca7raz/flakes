{ pkgs, lib, ... }:
{
  imports = [
    ./config.nix
    ./flood.nix
  ];

  systemd.services.qbittorrent = {
    documentation = [ "man:qbittorrent-nox(1)" ];
    description = "qBittorrent-nox service";
    wants = [
      "network-online.target"
    ];
    after = [
      "local-fs.target"
      "network-online.target"
      "nss-lookup.target"
    ];
    wantedBy = [
      "multi-user.target"
    ];

    serviceConfig = {
      Type = "exec";
      PrivateTmp = false;
      User = "torrent";
      Group = "media";
      TimeoutStopSec = 1800;
      ExecStart = builtins.concatStringsSep " " [
        "${lib.getExe pkgs.qbittorrent-nox}"
        "--profile=/var/lib/qbittorrent"
        "--relative-fastresume"
        "--confirm-legal-notice"
        "--webui-port=8082"
      ];

      StateDirectory = "qbittorrent";
    };
  };

  users.users.torrent = {
    group = "media";
    description = "User of Torrent Downloaders";
    isSystemUser = true;
  };
}
