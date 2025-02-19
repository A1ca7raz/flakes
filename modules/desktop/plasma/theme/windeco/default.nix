{
  nixosModule = { lib, config, user, ... }:
    with lib; let
      inherit (config.lib) themeColor;
      inherit (config.lib.theme) ThemeColor;

      kwinrc = mkRule "kwinrc";
    in {
      imports = [ ./config.nix ];

      environment.overlay = mkOverlayTree user {
        sierrabreezeenhancedrc = {
          target = c "sierrabreezeenhancedrc";
          source = config.utils.kconfig.files.sierrabreezeenhancedrc.path;
        };
      };

      utils.kconfig.rules = [
        # Window decorations
        (kwinrc "org.kde.kdecoration2" "theme" "Sierra Breeze Enhanced")
        (kwinrc "org.kde.kdecoration2" "library" "sierrabreezeenhanced")

        ## Titlebar Transparency
        (mkRule "sierrabreezeenhancedrc" "Windeco" "BackgroundOpacity" (
          if (ThemeColor == "Dark")
          then themeColor.dark.windecoOpacity
          else if (ThemeColor == "Light")
          then themeColor.light.windecoOpacity
          else "100"
        ))

        ## Window Border
        (kwinrc "org.kde.kdecoration2" "BorderSize" "None")
        (kwinrc "org.kde.kdecoration2" "BorderSizeAuto" "false")

        ## Titlebar Buttons
        (kwinrc "org.kde.kdecoration2" "ButtonsOnLeft" "XM")
        (kwinrc "org.kde.kdecoration2" "ButtonsOnRight" "IA")
        (kwinrc "org.kde.kdecoration2" "CloseOnDoubleClickOnMenu" "true")
      ];
    };

  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      (kdePackages.sierra-breeze-enhanced.overrideAttrs (p: {
        src = pkgs.fetchFromGitHub {
          owner = "kupiqu";
          repo = "SierraBreezeEnhanced";
          rev = "192ab107b228c832efb417131fb2dcf2b8d48f75";
          hash = "sha256-fXUGOKO7JoEWoAaGzFPoAVpu1/Vp73Elks/pjfOlGKw=";
        };
        patches = [
          (pkgs.fetchpatch {
            url = "https://github.com/kupiqu/SierraBreezeEnhanced/pull/144.patch";
            hash = "sha256-xPp/yOawFyh4X0sWhrC7vGkQwE/On3wPxcThzqZT93k=";
          })
        ];
      }))
    ];
  };
}
