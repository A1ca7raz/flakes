{ lib, user, config, ... }:
let
  inherit (lib) mkOverlayTree c;
in {
  imports = [
    ./module
  ];

  environment.overlay = mkOverlayTree user {
    desktop-appletsrc = {
      source = config.utils.kconfig.files.appletsrc.path;
      target = c "plasma-org.kde.plasma.desktop-appletsrc";
    };
  };
}
