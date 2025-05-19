{
  nixosModule = { lib, config, user, ... }:
    let
      inherit (lib)
        mkOverlayTree
        c
      ;

      inherit (config.lib) themeColor;
      inherit (config.lib.theme) ThemeColor;
    in {
      imports = [ ./config.nix ];

      environment.overlay = mkOverlayTree user {
        sierrabreezeenhancedrc = {
          target = c "sierrabreezeenhancedrc";
          source = config.utils.kconfig.sierrabreezeenhancedrc.path;
        };
      };

      utils.kconfig.kwinrc.content."org.kde.kdecoration2" = {
        ## Window decorations
        theme = "Sierra Breeze Enhanced";
        library = "sierrabreezeenhanced";

        ## Window Border
        BorderSize = "None";
        BorderSizeAuto = false;

        ## Titlebar Buttons
        ButtonsOnLeft = "XM";
        ButtonsOnRight = "IA";
        CloseOnDoubleClickOnMenu = true;
      };

      ## Titlebar Transparency
      utils.kconfig.sierrabreezeenhancedrc.content.Windeco.BackgroundOpacity =
        if (ThemeColor == "Dark")
          then themeColor.dark.windecoOpacity
          else if (ThemeColor == "Light")
          then themeColor.light.windecoOpacity
          else "100";
    };

  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      sierra-breeze-enhanced-git
    ];
  };
}
