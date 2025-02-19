{ home, pkgs, ... }:
{
  home.packages = with pkgs; [
    (kdePackages.applet-window-buttons6.overrideAttrs (p: {
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/moodyhunter/applet-window-buttons6/pull/22.patch";
        })
      ];
    }))
    plasma-panel-colorizer-nightly
    plasma-panel-spacer-extended
    kara
    plasmusic-toolbar
    kwin-gestures
  ];
}
