{ self, lib, templates, ... }:
{
  imports = [ templates.vps ];

  targetHost = "redacted";
  hostName = "rock";
  tags = with lib.tags; [
    public
  ];

  modules = with self.modules; [
    system.bootloader.legacy.grub
    system.kernel.xanmod

    services.external.sing-box
  ];
}
