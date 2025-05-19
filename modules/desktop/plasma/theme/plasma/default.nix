{
  nixosModule = { config, ... }:
    let
      inherit (config.lib.theme) PlasmaTheme;
    in {
      utils.kconfig.plasmarc.content.Theme.name = PlasmaTheme;
      utils.kconfig.ksplashrc.content.KSplash.Theme = "Arch-Splash";
    };

  homeModule = { pkgs, ... }: {
    home.sessionVariables.GTK_USE_PORTAL = "1";
  };
}
