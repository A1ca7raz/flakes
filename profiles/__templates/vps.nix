{ self, lib, ... }:
{
  targetPort = lib.mkDefault 48422;
  # targetUser = "nomad";
  system = lib.mkDefault "x86_64-linux";
  tags = [ lib.tags.server ];

  modules = with self.modules; [
    nix.settings

    programs.shell.misc

    services.common.openssh

    (system.boot.exclude ["console"])
    system.misc
    system.network.base
    system.network.headless
    system.network.systemd
    system.security.pki
    system.security.sudo
    system.security.oomd

    users.root
  ];
}
