{ self, lib, templates, ... }:
{
  imports = [ templates.vps ];

  targetHost = "redacted";
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

    # TODO: tunnelbroker 的配置加密，与 nixpkgs networkd 共存
    # ({ secrets, const, ... }: {
    #   utils.encrypted.networkd.v6tunnel = {

    #   };
    # })
  ];
}
