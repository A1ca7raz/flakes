{
  nixosModule = { config, user, lib, ... }:
    with lib; let
      inherit (config.lib.theme) KvantumTheme;
    in {
      utils.kconfig.kvconfig.content.General.theme = KvantumTheme;
      utils.kconfig.kdeglobals.content.KDE.widgetStyle = "kvantum";

      # Persistence
      environment.persistence = mkPersistDirsTree user [
        (c "Kvantum")
      ];
      environment.overlay = mkOverlayTree user {
        kvconfig = {
          source = config.utils.kconfig.kvconfig.path;
          target = c "Kvantum/kvantum.kvconfig";
        };
      };
    };

  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum  # For Qt5 Applications
    ];
  };
}
