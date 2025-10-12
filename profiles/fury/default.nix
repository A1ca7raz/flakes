{ self, lib, templates, ... }:
{
  imports = [];

  targetHost = "";
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

    system.bootloader.efi.grub.local
    system.kernel.xanmod
  ];
}
