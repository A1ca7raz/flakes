{ config, lib, ... }:
let
  cfg = config.systemd.services.qbittorrent;

  iface = config.systemd.network.networks.default.matchConfig.Name;
  user = cfg.serviceConfig.User;
  group = cfg.serviceConfig.Group;
  mediaDir = "/mnt/media";
  saveDir = "${mediaDir}/Download";
  torrentDir = "${mediaDir}/Torrents";
in {
  utils.kconfig.qbittorrent.content = {
    Core.AutoDeleteAddedTorrentFile = "IfAdded";
    LegalNotice.Accepted = true;

    BitTorrent = {
      "Session\\DefaultSavePath" = saveDir;
      "Session\\DisableAutoTMMByDefault" = false;
      "Session\\ExcludedFileNames" = "";
      "Session\\FinishedTorrentExportDirectory" = "${torrentDir}/.completed";
      "Session\\GlobalMaxRatio" = 15;
      "Session\\IgnoreLimitsOnLAN" = true;
      "Session\\Interface" = iface;
      "Session\\InterfaceName" = iface;
      "Session\\PerformanceWarning" = true;
      "Session\\Port" = 63003;
      "Session\\QueueingSystemEnabled" = false;
      "Session\\SSL\\Port" = 47733;
      "Session\\TempPath" = "${saveDir}/.downloading";
      "Session\\TempPathEnabled" = true;
      "Session\\uTPRateLimited" = false;
    };

    Preferences = {
      "General\\Locale" = "zh_CN";
      "MailNotification\\req_auth" = true;
      "WebUI\\Address" = "192.168.100.254";
      "WebUI\\AuthSubnetWhitelist" = "192.168.0.0/16";
      "WebUI\\AuthSubnetWhitelistEnabled" = true;
      "WebUI\\LocalHostAuth" = false;
      "WebUI\\Port" = 8082;
    };
  };

  systemd.tmpfiles.settings.torrent-downloading = {
    "${saveDir}".d = {
      mode = "0775";
      inherit user group;
    };
    "${torrentDir}".d = {
      mode = "0775";
      inherit user group;
    };
  };

  systemd.services.qbittorrent.serviceConfig.ExecStartPre = [
    "${lib.getExe config.utils.kconfig.qbittorrent.script} $\{STATE_DIRECTORY\}/qBittorrent/config/qBittorrent.conf"
  ];
}
