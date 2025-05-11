{ self, lib, templates, ... }:
{
  imports = [ templates.desktop ];

  targetHost = "192.168.10.3";
  targetPort = 22;
  targetUser = "nomad";
  hostName = "oxygenlaptop";

  tags = with lib.tags; [
    local internal private physical
    laptop
  ];

  modules = with self.modules; [
    desktop.plasma

    hardware.amdcpu
    hardware.amdgpu
    hardware.deep_sleep
    hardware.logitech
    hardware.nvme
    hardware.printing
    hardware.tpm
    hardware.xbox

    (programs.desktop.exclude [
      "messaging.matrix"
      "graphics.krita"
    ])

    (services.desktop.exclude [
      "webai"
    ])

    system.kernel.xanmod
    system.security.secureboot
    # system.security.kwallet
  ];
}
