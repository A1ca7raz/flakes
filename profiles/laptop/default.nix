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
    hardware.touchpad
    # hardware.deep_sleep
    hardware.nvme
    hardware.printing
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

    (services.desktop.exclude [
      "webai"
    ])
    services.ai.sillytavern
    system.kernel.xanmod
    system.security.secureboot
    # system.security.kwallet

    ({ lib, ... }: {
      systemd.services.sillytavern.wantedBy = lib.mkForce [];
    })
  ];
}
