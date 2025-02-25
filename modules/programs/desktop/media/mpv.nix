# SVP Support:
# https://lantian.pub/article/modify-computer/nixos-packaging.lantian/#%E5%9B%B0%E9%9A%BEsvp%E7%A8%8B%E5%BA%8F%E6%A3%80%E6%B5%8B%E8%87%AA%E8%BA%AB%E5%AE%8C%E6%95%B4%E6%80%A7bubblewrap
# https://github.com/LunNova/nixos-configs/blob/dev/users/lun/gui/media/default.nix
# https://github.com/LunNova/nixos-configs/blob/dev/packages/svpflow/default.nix
{ home, pkgs, ... }:
with pkgs; let
  mpvPackage = mpv-unwrapped.wrapper {
    mpv = mpv-unwrapped.override { vapoursynthSupport = true; };
    scripts = with mpvScripts; [
      mpris                 # Mpris
      thumbfast             # On-the-fly Thumbnail
      uosc                  # Feature-rich UI
      # autoload
    ];
  };
in {
  lib.packages.mpv = mpvPackage;

  programs.mpv = {
    enable = true;
    package = mpvPackage;

    config = {
      scale = "ewa_hanning";
      cscale = "bilinear";
      dscale = "ewa_hanning";
      # video-sync = "display-resample";
      # interpolation = true;
      save-position-on-quit = true;
      hwdec = "auto";
      hwdec-codecs = "all";
      vo = "gpu-next";
      volume-max = 150;

      wayland-disable-vsync = true;

      # Network stream cache
      demuxer-max-bytes = "400MiB";       # forward cache
      demuxer-max-back-bytes = "100MiB";  # At least 100MiB memory space for backward cache
      demuxer-donate-buffer = true;      # Allow backward cache 'borrow' space from forward cache (for live stream, total 500MiB available for backward cache)
      demuxer-hysteresis-secs = 10;       # extra cache when 500MiB run out
    };

    bindings = {
      "[" =	"add speed -0.25";
      "]" =	"add speed 0.25";
    };

    scriptOpts.uosc = {
      timeline_style = "bar";
      timeline_size = 25;
      timeline_opacity = 0.7;

      controls_margin = 4;
      controls_spacing = 4;

      volume_size = 35;
      volume_size_fullscreen = 40;
      volume_opacity = 0.5;
      volume_step = 5;
    };
  };
}
