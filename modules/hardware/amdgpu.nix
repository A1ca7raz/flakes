{ pkgs, ... }:
{
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [
      "amdgpu.vm_update_mode=3"
      "radeon.dpm=1"
    ];
  };

  hardware.amdgpu.initrd.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = [
    pkgs.nvtopPackages.amd
  ];
}
