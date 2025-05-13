{ lib, config, variables, ... }:
{
  utils.netns.veth.step = {
    bridge = "global";
    netns = "step";
    ipAddrs = variables.services.pki.x1.cidr;
  };

  systemd.services.step-ca = lib.mkIf config.utils.netns.enable {
    after = [ "netns-veth-step.service" ];
    bindsTo = [ "netns-veth-step.service" ];

    # serviceConfig.NetworkNamespacePath = "/run/netns/step";
    unitConfig.JoinsNamespaceOf = [ "netns@step.service" ];
    serviceConfig.BindReadOnlyPaths = [ "/etc/netns/step/resolv.conf:/etc/resolv.conf" ];
    serviceConfig.PrivateNetwork = true;
  };
}
