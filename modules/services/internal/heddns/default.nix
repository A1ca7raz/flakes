{ pkgs, config, secrets, const, lib, ... }:
let
  inherit (lib.generators) toKeyValue;
in {
  utils.secrets."host/ddns/hostname".path = secrets.hosts.${const.node.profileName};
  utils.secrets."host/ddns/secret".path = secrets.hosts.${const.node.profileName};
  # TODO: 写一个快速从密文生成 env 的模块？
  sops.templates."ddns.env".content = toKeyValue {} {
    DDNS_HOSTNAME = config.sops.placeholder."host/ddns/hostname";
    DDNS_SECRET = config.sops.placeholder."host/ddns/secret";
  };

  systemd.services.heddns = {
    description = "Hurricane Electric DDNS Updater";

    serviceConfig = {
      Type = "oneshot";
      User = "nobody";
      Group = "systemd-journal";

      EnvironmentFile = config.sops.templates."ddns.env".path;
    };

    script = builtins.concatStringsSep " " [
      ''${pkgs.curl}/bin/curl''
      ''-6 "https://dyn.dns.he.net/nic/update"''
      ''-d "hostname=$DDNS_HOSTNAME"''
      ''-d "password=$DDNS_SECRET"''
    ];
  };

  systemd.timers.heddns = {
    description = "Hurricane Electric DDNS Updater Hourly Cron Job";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    timerConfig = {
      OnCalendar = "*-*-* *:20:04";
      Persistent = true;
    };
  };
}
