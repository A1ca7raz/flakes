{ ... }:
{
  # environment.overlay = mkOverlayTree user {
  #   MyDarkColor = mk "MyDark";
  #   MyLightColor = mk "MyLight";
  # };

  utils.kconfig.kdeglobals.content.General.ColorScheme = "light";
}
