{
  nixosModule = { pkgs, lib, user, ... }: {
    programs.niri = {
      enable = true;
      package = pkgs.niri-nighty;
    };

    xdg.portal.configPackages = [ pkgs.niri-nighty ];
  };

  homeModule = { pkgs, lib, ... }: {
    xdg.configFile."niri/config.kdl".text =
      lib.foldGetFile ./config "" (
        f: acc:
        if lib.hasSuffix ".kdl" f
        then acc + "\n" + builtins.readFile ./config/${f}
        else acc
      );

    home.packages = with pkgs; [
      brightnessctl # Screen Brightness Control
      alacritty
    ];
  };
}
