{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver  # Enable Hardware Acceleration
      vpl-gpu-rt # or intel-media-sdk for QSV
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ intel-vaapi-driver ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  environment.systemPackages = with pkgs; [
    nvtopPackages.intel
    libva-utils # Test vaapi
  ];
}
