{ home, pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.applet-window-buttons6
    plasma-panel-colorizer-nighty
    plasma-panel-spacer-extended
    kara
    plasmusic-toolbar
    plasma-applet-window-title6
    kurve
    # kwin-gestures

    flameworkPackages.kde-desktop-theme
  ];
}
