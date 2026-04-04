{
  nixosModule = { config, user, lib, ... }: {
    utils.kconfig.kvconfig.content.General.theme = "A1ca7raz-Light";
    utils.kconfig.kdeglobals.content.KDE.widgetStyle = "kvantum";

    environment.overlay = lib.mkOverlayTree user {
      kvconfig = {
        source = config.utils.kconfig.kvconfig.path;
        target = lib.c "Kvantum/kvantum.kvconfig";
      };
    };
  };

  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
    ];
  };
}
