{ pkgs, ... }:
{
  services.libinput = {
    enable = true;
    touchpad = {
      horizontalScrolling = true;
      naturalScrolling = true;
      tapping = true;
      tappingDragLock = false;
    };
  };

  # hardware.steam-hardware.enable = true;

  hardware.graphics.enable = true;
}
