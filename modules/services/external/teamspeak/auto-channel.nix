{ pkgs, secrets, std, config, ... }:
let
  bin = "${pkgs.teamspeak-management-tools}/bin/teamspeak-management-tools";
in {
  utils.secrets."teamspeak/serveradmin_token".path = secrets.services.teamspeak;
  sops.templates."auto-channel.toml".content = std.serde.toTOML {
    server = {
      server-id = 1;
      channel-id = [ 2 ];
      privilege-group-id = 5;
      leveldb = "/var/lib/teamspeak-management-tools/cache.db";
    };

    mute-porter = {
      enable = false;
      monitor = 2;
      target = 1;
      whitelist = [];
    };

    telegram = {
      api-key = "";
      target = 0;
    };

    misc = {};

    raw-query = {
      server = "127.0.0.1";
      port = 10011;
      user = "serveradmin";
      password = config.sops.placeholder."teamspeak/serveradmin_token";
    };
  };

  systemd.services.teamspeak-management-tools = {
    wantedBy = [ "multi-users.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    environment.RUST_LOG = "debug";

    serviceConfig = {
      Type = "simple";
      ExecStart = "${bin} --systemd %d/config.toml";
      LoadCredential = "config.toml:${config.sops.templates."auto-channel.toml".path}";
      User = "teamspeak-management-tools";
      Group = "teamspeak-management-tools";
      WorkingDirectory = "/var/lib/teamspeak-management-tools";
      StateDirectory = "teamspeak-management-tools";

      # Light-weight Harden
      DynamicUser = true;
      AmbientCapabilities = [ ];
      CapabilityBoundingSet = [ ];
      LimitNOFILE = 1048576;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectProc = "invisible";
      RemoveIPC = true;
      ProtectControlGroups = true;
      ProtectKernelTunables = true;
    };
  };
}
