{ modulesPath, lib, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  services.qemuGuest.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
