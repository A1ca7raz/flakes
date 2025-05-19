{
  nixosModule = { config, ... }:
    let
      inherit (config.lib.theme) IconTheme;
    in {
      utils.kconfig.kdeglobals.content.Icons.Theme = IconTheme.name;
    };

  homeModule = { config, ... }: {
    home.packages = [ config.lib.theme.IconTheme.package ];
  };
}
