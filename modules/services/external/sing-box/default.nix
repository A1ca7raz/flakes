{ ... }:
{
  imports = [
    ./config.nix
  ];

  services.sing-box.enable = true;

  services.sing-box.settings = {
    log.level = "info";

    dns.servers = [
      { address = "tls://1.1.1.1"; }
    ];

    outbounds = [
      { tag = "DIRECT"; type = "direct"; }
    ];
  };

  # Service Harden
  systemd.services.sing-box.serviceConfig = {
    DynamicUser = "yes";
    # Capabilities
    # CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    # AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    # Proc filesystem
    ProcSubset = "pid";
    ProtectProc = "invisible";
    # Security
    NoNewPrivileges = true;
    # Sandboxing
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    # PrivateDevices = true;        # NOT WORK for listening on ports
    PrivateMounts = true;
    PrivateTmp = true;
    # PrivateUsers = true;          # NOT WORK for listening on ports
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectSystem = "strict";
    RemoveIPC = true;
    RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_NETLINK" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    # System Call Filtering
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid" "setrlimit" ];
  };
}
