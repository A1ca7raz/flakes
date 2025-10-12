{ self, lib, templates, variables, ... }:
{
  imports = [ templates.vps ];

  targetHost = "192.168.1.100";
  hostName = "oxygenbox";
  tags = with lib.tags; [
    "home"
    private
  ];

  modules = with self.modules; [
    hardware.intelcpu

    system.network.netns
    system.bootloader.efi.grub.removable
    system.kernel.xanmod

    services.common.postgresql
    services.common.redis
    services.common.caddy
    services.common.knot

    services.ai.sillytavern

    services.external.step-ca
    # services.external.alist

    services.internal.heddns
    services.internal.immich
    services.internal.jellyfin
    services.internal.torrent
    services.internal.sharing
    services.internal.moviepilot

    {
      # PostgreSQL Tune
      # https://pgtune.leopard.in.ua/
      services.postgresql.settings = {
        # DB Version: 16
        # OS Type: linux
        # DB Type: mixed
        # Total Memory (RAM): 4 GB
        # CPUs num: 4
        # Connections num: 100
        # Data Storage: ssd
        max_connections = 100;
        shared_buffers = "1GB";
        effective_cache_size = "3GB";
        maintenance_work_mem = "256MB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "16MB";
        default_statistics_target = 100;
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        work_mem = "5041kB";
        huge_pages = "off";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
        max_worker_processes = 4;
        max_parallel_workers_per_gather = 2;
        max_parallel_workers = 4;
        max_parallel_maintenance_workers = 2;
      };
    }

    {
      utils.netns.bridge = {
        homelab.ipAddrs = variables.vnet.homelab;
        global.ipAddrs = variables.vnet.global;
      };

      # Disable AI for J1900
      services.immich.machine-learning.enable = false;
    }
  ];
}
