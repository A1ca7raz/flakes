{ lib, ... }:
{
  boot.kernelParams = [
    "amd_pstate=passive"
    "amd_iommu=off"       # NOTE: fix broken suspend
  ];
  boot.kernelModules = [ "kvm-amd" ];

  hardware.cpu.amd.updateMicrocode = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
