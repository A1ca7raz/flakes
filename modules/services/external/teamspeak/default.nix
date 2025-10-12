{ pkgs, config, ... }:
let
  ts3 = pkgs.teamspeak_server;
  user = "teamspeak";
  group = user;
  dataDir = "/var/lib/teamspeak3-server";
  logPath = "/var/log/teamspeak3-server";

  defaultVoicePort = 9987;
  fileTransferPort = 30033;
  queryPort = 10011;
  querySshPort = 10022;
  queryHttpPort = 10080;
in {
  imports = [
    ./auto-channel.nix
  ];

  # services.teamspeak3.enable = true;
  users.users.teamspeak = {
    description = "Teamspeak3 voice communication server daemon";
    group = group;
    uid = config.ids.uids.teamspeak;
    home = dataDir;
    createHome = true;
  };

  users.groups.teamspeak = {
    gid = config.ids.gids.teamspeak;
  };

  systemd.tmpfiles.rules = [
    "d '${logPath}' - ${user} ${group} - -"
  ];

  systemd.services.teamspeak3-server = {
    description = "Teamspeak3 voice communication server daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${ts3}/bin/ts3server \
          dbsqlpath=${ts3}/lib/teamspeak/sql/ \
          logpath=${logPath} \
          license_accepted=1 \
          default_voice_port=${toString defaultVoicePort} \
          filetransfer_port=${toString fileTransferPort} \
          query_port=${toString queryPort} \
          query_ssh_port=${toString querySshPort} \
          query_http_port=${toString queryHttpPort}
      '';
      WorkingDirectory = dataDir;
      User = user;
      Group = group;
      Restart = "on-failure";
    };
  };
}
