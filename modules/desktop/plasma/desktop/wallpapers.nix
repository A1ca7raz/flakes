{ ... }:
let
  usePotd = {
    wallpaperPlugin = "org.kde.potd";
    wallpaperConfig.General = {
      FillMode = 2;
      Provider = "bing";
    };
  };

  useImage = {
    wallpaperPlugin = "org.kde.image";
    wallpaperConfig.General.Image = "/run/current-system/sw/share/wallpapers/Next/";
  };
in {
  utils.plasma.monitors = {
    main = usePotd;
    secondary = usePotd;
  };
}
