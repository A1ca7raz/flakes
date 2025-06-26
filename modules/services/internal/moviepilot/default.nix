{ pkgs, config, ... }:
{
  imports = [
    ./proxy.nix
  ];

  systemd.services.moviepilot = {
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

    environment = {
      CONFIG_DIR = "/var/lib/moviepilot";
      UMASK = "002";

      MOVIEPILOT_AUTO_UPDATE = "false";
      SUBSCRIBE_STATISTIC_SHARE = "false";
      PLUGIN_STATISTIC_SHARE = "false";

      DOH_ENABLE = "false";
    };

    path = with pkgs; [
      fuse3
      ffmpeg
      rsync
      procps
      nano
      rclone
      wget
      curl
      python312Packages.playwright
    ];

    preStart = ''
      playwright install chromium
    '';

    serviceConfig = {
      Type = "exec";
      User = "moviepilot";
      Group = "media";
      UMask = "0002";
      TimeoutStopSec = 1800;

      ExecStart = "${pkgs.moviepilot}/bin/moviepilot";

      WorkingDirectory = "/var/lib/moviepilot";
      StateDirectory = "moviepilot";

      # Light-weight Harden
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      LimitNOFILE = 1048576;
      # PrivateTmp = true;
      # ProtectSystem = "strict";
      # ProtectProc = "invisible";
      # RemoveIPC = true;
      # ProtectControlGroups = true;
      # ProtectKernelTunables = true;
    };
  };

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 5242880;
    "fs.inotify.max_user_instances" = 5242880;
  };

  networking.extraHosts = ''
    54.240.174.47 api.themoviedb.org
    54.240.174.124 api.themoviedb.org
    54.240.174.81 api.themoviedb.org
    54.240.174.3 api.themoviedb.org
  '';

  users.users.moviepilot = {
    group = "media";
    isSystemUser = true;
    home = "/var/lib/moviepilot";
  };
}
