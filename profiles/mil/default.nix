{ self, lib, templates, ... }:
{
  imports = [ templates.vps ];

  targetHost = "redact";
  hostName = "mil";
  tags = with lib.tags; [
    public
  ];

  modules = with self.modules; [
    hardware.qemu

    system.bootloader.legacy.grub
    system.kernel.xanmod
    system.network.systemd-static

    # services.external.sing-box
  ];
}
