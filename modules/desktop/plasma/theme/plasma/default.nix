{
  nixosModule = { config, ... }: {
    utils.kconfig.plasmarc.content.Theme.name = "light";
    utils.kconfig.ksplashrc.content.KSplash.Theme = "splash";
  };

  homeModule = { pkgs, ... }: {
    home.sessionVariables.GTK_USE_PORTAL = "1";
  };
}
