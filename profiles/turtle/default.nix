{ self, lib, templates, ... }:
{
  imports = [ templates.vps ];

  targetHost = "redacted";
  hostName = "turtle";
  tags = with lib.tags; [
    public
  ];

  modules = with self.modules; [
    hardware.qemu

    system.bootloader.legacy.grub
    system.kernel.xanmod

    services.external.teamspeak
  ];
}
