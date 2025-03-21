{
  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "chromium")
    ];

  homeModule = { pkgs, ... }: {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium-drm;
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];
      # NOTE: extensions does not work for ungoogled-chromium
    };

    xdg.mimeApps.defaultApplications =
      let
        chromium = "chromium-browser.desktop";
      in {
        "x-scheme-handler/http" = chromium;
        "x-scheme-handler/https" = chromium;
        "text/html" = chromium;
      };
  };
}
