{ home, pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.applet-window-buttons6
    plasma-panel-colorizer-nightly
    plasma-panel-spacer-extended
    kara
    plasmusic-toolbar
    kwin-gestures
  ];
}
