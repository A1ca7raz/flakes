{ self, lib, templates, ... }:
{
  imports = [ templates.vps ];

  targetHost = "redact";
  hostName = "volt";
  tags = with lib.tags; [
    public
  ];

  modules = with self.modules; [
    hardware.qemu

    system.bootloader.legacy.grub
    system.kernel.xanmod
    system.network.systemd

    services.external.sing-box
  ];
}
