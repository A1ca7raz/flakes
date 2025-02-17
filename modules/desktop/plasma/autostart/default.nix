{
  homeModule = { pkgs, ... }:
    let
      mkLink = x: {
        target = "autostart/${x}.desktop";
        source = ./autostart/${x}.desktop;
      };
    in {
      xdg.configFile = {
        autostart_birdtray = mkLink "birdtray";
        autostart_keepassxc = mkLink "keepassxc";
        autostart_steam = mkLink "steam";
        autostart_yakuake = mkLink "yakuake";
        autostart_tg = mkLink "telegram";
      };
    };

  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "autostart")
    ];
}
