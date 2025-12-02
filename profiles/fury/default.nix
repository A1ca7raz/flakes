{ self, lib, templates, variables, ... }:
{
  imports = [ templates.vps ];

  targetHost = "192.168.10.100";
  targetUser = "root";
  hostName = "fury";

  tags = with lib.tags; [
    local
    internal
    private
  ];

  modules = with self.modules; [
    hardware.intelcpu
    hardware.intelgpu
    hardware.nvme
    hardware.tpm
    hardware.cx

    nix.mirrors

    system.network.netns
    system.bootloader.efi.systemd
    system.kernel.xanmod

    services.common.postgresql
    services.common.redis
    services.common.caddy
    services.common.knot

    services.internal.heddns
    services.internal.immich
    services.internal.jellyfin
    services.internal.torrent
    services.internal.sharing
    services.internal.moviepilot

    services.ai.sillytavern

    services.external.step-ca

    {
      # PostgreSQL Tune
      # https://pgtune.leopard.in.ua/
      services.postgresql.settings = {
        # DB Version: 16
        # OS Type: linux
        # DB Type: mixed
        # Total Memory (RAM): 16 GB
        # CPUs num: 8
        # Connections num: 100
        # Data Storage: ssd
        max_connections = 100;
        shared_buffers = "4GB";
        effective_cache_size = "12GB";
        maintenance_work_mem = "1GB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "16MB";
        default_statistics_target = 100;
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        work_mem = "19418kB";
        huge_pages = "off";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
        max_worker_processes = 8;
        max_parallel_workers_per_gather = 4;
        max_parallel_workers = 8;
        max_parallel_maintenance_workers = 4;
      };
    }

    {
      utils.netns.bridge = {
        homelab.ipAddrs = variables.vnet.homelab;
        global.ipAddrs = variables.vnet.global;
      };

      services.immich.machine-learning.enable = false;  # Broken

      systemd.network.networks.default.matchConfig.Name = "eth1"; # use external nic
    }
  ];
}
