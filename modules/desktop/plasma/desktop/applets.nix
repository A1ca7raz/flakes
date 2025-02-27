{ home, pkgs, ... }:
{
  home.packages = with pkgs; [
    (kdePackages.applet-window-buttons6.overrideAttrs (p: {
      src = pkgs.fetchFromGitHub {
        owner = "moodyhunter";
        repo = "applet-window-buttons6";
        rev = "326382805641d340c9902689b549e4488682f553";
        hash = "sha256-POr56g3zqs10tmCbKN+QcF6P6OL84tQNkA+Jtk1LUfY=";
      };
      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/moodyhunter/applet-window-buttons6/pull/22.patch";
          hash = "sha256-1GwZh2ZR9+cB+4ggiwsNN1KT5m8tsi/AEGZK0Cx5sdw=";
        })
      ];
    }))
    plasma-panel-colorizer
    plasma-panel-spacer-extended
    kara
    plasmusic-toolbar
    kwin-gestures
  ];
}
