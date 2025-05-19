{ config, lib, ... }:
{
  utils.kconfig.qbittorrent.content = {
    Core.AutoDeleteAddedTorrentFile = "IfAdded";
    LegalNotice.Accepted = true;

    BitTorrent = {
      "Session\\DefaultSavePath" = "/mnt/media/Downloads";
      "Session\\DisableAutoTMMByDefault" = false;
      "Session\\ExcludedFileNames" = "";
      "Session\\FinishedTorrentExportDirectory" = "/mnt/media/Torrents/.completed";
      "Session\\GlobalMaxRatio" = 15;
      "Session\\IgnoreLimitsOnLAN" = true;
      "Session\\Interface" = "eth0";
      "Session\\InterfaceName" = "eth0";
      "Session\\PerformanceWarning" = true;
      "Session\\Port" = 63003;
      "Session\\QueueingSystemEnabled" = false;
      "Session\\SSL\\Port" = 47733;
      "Session\\TempPath" = "/mnt/media/.downloading";
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

  systemd.services.qbittorrent.serviceConfig.ExecStartPre = [
    "${lib.getExe config.utils.kconfig.qbittorrent.script} $\{STATE_DIRECTORY\}/qBittorrent/config/qBittorrent.conf"
  ];
}
