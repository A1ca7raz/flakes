{ pkgs, ... }:
{
  imports = [
    ./proxy.nix
  ];

  # FIXME: impure implement
  # Initialize sillytavern and rsync data directory and config.yaml to state directory
  systemd.services.sillytavern = {
    description = "SillyTavern";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [
      git
    ];
    serviceConfig = {
      Type = "simple";
      ExecStartPre = [
        "${pkgs.coreutils}/bin/cp -f ${./config.yaml} /var/lib/sillytavern/config.yaml"
        "${pkgs.coreutils}/bin/chmod +w /var/lib/sillytavern/config.yaml"
      ];
      ExecStart = "${pkgs.sillytavern-nightly}/bin/sillytavern --dataRoot /var/lib/sillytavern/data";
      User = "sillytavern";
      Group = "sillytavern";
      StateDirectory = "sillytavern";
      WorkingDirectory = "/var/lib/sillytavern";

      Restart = "on-failure";
      RestartSec = "3s";

      CapabilityBoundingSet = [ "" ];
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      # RestrictAddressFamilies = [
      #   "AF_UNIX"
      #   "AF_INET"
      #   "AF_INET6"
      # ];
      # RestrictNamespaces = true;
      # RestrictRealtime = true;
      # RestrictSUIDSGID = true;
      # SystemCallArchitectures = "native";
      # SystemCallFilter = [
      #   "@system-service"
      #   "@pkey"
      #   "~@privileged"
      # ];
    };
  };

  users.users.sillytavern = {
    group = "sillytavern";
    isSystemUser = true;
  };
  users.groups.sillytavern = {};
}
