{
  nixosModule = { config, ... }:
    let
      inherit (config.lib.theme) CursorTheme;
    in {
      utils.kconfig.kcminputrc.content.Mouse.cursorTheme = CursorTheme.name;
    };

  homeModule = { config, ... }: {
    home.packages = [ config.lib.theme.CursorTheme.package ];
  };
}
