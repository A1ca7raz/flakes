{ ... }:
{
  imports = [
    ./proxy.nix
  ];

  services.immich = {
    enable = true;
    host = "127.100.0.1"; # Immich will check sni, better to set IP

    # PostgreSQL: Default, use unixsocket
    # Redis: Default, use unixsocket

    accelerationDevices = [
      "/dev/dri/renderD128"
    ];

    settings = null;  # Allows configuring Immich in the Web UI

    machine-learning.environment = {
      MACHINE_LEARNING_REQUEST_THREADS = "2";
    };
  };
}
