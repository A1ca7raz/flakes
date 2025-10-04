{ pkgs, ... }:
let
  user = "sillytavern";
  group = user;
in {
  imports = [
    # ./proxy.nix
  ];

  systemd.tmpfiles.settings.sillytavern = {
    "/var/lib/SillyTavern/data".d = {
      mode = "0700";
      inherit user group;
    };
    "/var/lib/SillyTavern/extensions".d = {
      mode = "0700";
      inherit user group;
    };
    "/var/lib/SillyTavern/config.yaml"."L+" = {
      mode = "0600";
      argument = "${pkgs.sillytavern}/lib/node_modules/sillytavern/config.yaml";
      inherit user group;
    };
  };

  systemd.services.sillytavern = {
    description = "SillyTavern";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      git
    ];
    environment.XDG_DATA_HOME = "%S";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.sillytavern}/bin/sillytavern";
      User = user;
      Group = group;
      StateDirectory = "SillyTavern";
      BindPaths = [
        "/var/lib/SillyTavern/extensions:${pkgs.sillytavern}/lib/node_modules/sillytavern/public/scripts/extensions/third-party"
      ];

      Restart = "on-failure";
      RestartSec = "3s";

      #CapabilityBoundingSet = [ "" ];
      #LockPersonality = true;
      #NoNewPrivileges = true;
#       PrivateDevices = true;
#       PrivateTmp = true;
#       ProtectClock = true;
#       ProtectControlGroups = true;
#       ProtectHome = true;
#       ProtectHostname = true;
#       ProtectKernelLogs = true;
#       ProtectKernelModules = true;
#       ProtectKernelTunables = true;
#       ProtectProc = "invisible";
#       ProtectSystem = "strict";
    };
  };

  users.users."${user}" = {
    inherit group;
    isSystemUser = true;
  };
  users.groups."${group}"= {};
}
