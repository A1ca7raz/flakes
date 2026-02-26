{ lib, user, config, ... }:
let
  inherit (lib)
    mkOverlayTree
    c
  ;
in {
  environment.overlay = mkOverlayTree user {
    desktop-appletsrc = {
      source = config.utils.kconfig.appletsrc.path;
      target = c "plasma-org.kde.plasma.desktop-appletsrc";
    };
  };
}
