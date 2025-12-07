{ self, lib, templates, ... }:
{
  imports = [ templates.desktop ];

  targetHost = "192.168.10.11";
  targetPort = 48422;
  targetUser = "nomad";
  hostName = "oxygenstation";
  deployAsRoot = true;

  tags = with lib.tags; [
    local internal private physical
  ];

  modules = with self.modules; [
    desktop.plasma

    hardware.amdcpu
    hardware.nvidia
    hardware.cx
    hardware.bluetooth
    # hardware.deep_sleep
    hardware.nvme
    hardware.tpm
    hardware.xbox

    (programs.desktop.exclude [
      "entertainment.maa"
      "graphics.krita"
      "graphics.gimp"
      "development.jetbrains"
      "development.virt-manager"
      "media.dmlive"
      "browsers.thunderbird"
    ])

    services.common.openssh

#     (services.desktop.exclude [
#       "webai"
#     ])
    system.kernel.xanmod
#     system.security.secureboot
    system.bootloader.efi.systemd
    # system.security.kwallet
  ];
}
