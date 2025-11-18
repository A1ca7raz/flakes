{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

#   hardware.nvidia.enabled = true;
  hardware.nvidia.open = true;

  environment.systemPackages = [
    pkgs.nvtopPackages.nvidia
  ];

  boot.blacklistedKernelModules = [
    "nouveau"
  ];

  services.xserver.videoDrivers = ["nvidia"];
}
