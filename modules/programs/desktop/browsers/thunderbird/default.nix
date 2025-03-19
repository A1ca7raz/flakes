{
  nixosModule = { user,  lib, ... }:
    with lib; mkMerge [
      (mkPersistDirsModule user [
        # ".mozilla/thunderbird"
        ".thunderbird"
      ])
      (mkOverlayModule user {
        birdtray-config = {
          target = c "birdtray-config.json";
          source = ./birdtray-config.json;
        };
      })
    ];

  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      birdtray
      thunderbird
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/mailto" = "thunderbird.desktop";
      };
    };
  };
}
