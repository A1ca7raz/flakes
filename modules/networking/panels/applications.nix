{ ... }:
{
  systemd.network.netdevs.dummy_srv_external = {
    netdevConfig = {
      Kind = "dummy";
      Name = "dummy-srv-ext";
      Description = "Dummy interface for network panel of external services";
    };
  };

  systemd.network.netdevs.dummy_srv_internal = {
    netdevConfig = {
      Kind = "dummy";
      Name = "dummy-srv-int";
      Description = "Dummy interface for network panel of internal services";
    };
  };

  systemd.network.networks.dummy_srv_external = {
    matchConfig = {
      Name = "dummy-srv-ext";
    };
    networkConfig = {
      Address = "192.168.100.100/24";
    };
  };

  systemd.network.networks.dummy_srv_internal = {
    matchConfig = {
      Name = "dummy-srv-int";
    };
    networkConfig = {
      Address = "192.168.100.101/24";
    };
  };
}
