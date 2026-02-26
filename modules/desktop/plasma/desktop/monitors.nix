{ ... }:
let
  wallpaperPotd = {
    wallpaperPlugin = "org.kde.potd";
    wallpaperConfig.General = {
      FillMode = 2;
      Provider = "bing";
    };
  };

  wallpaperImage = {
    wallpaperPlugin = "org.kde.image";
    wallpaperConfig.General.Image = "/run/current-system/sw/share/wallpapers/Next/";
  };
in {
  utils.plasma.monitors = {
    main = {
      id = 11;
      lastScreen = 0;
    } // wallpaperPotd;

    secondary = {
      id = 21;
      lastScreen = 1;
    } // wallpaperPotd;
  };
}
