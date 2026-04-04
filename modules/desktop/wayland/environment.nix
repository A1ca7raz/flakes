{ user, lib, ... }:
{
  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";   # Firefox
      NIXOS_OZONE_WL = "1";       # Chromium
    };

    persistence = with lib; mkPersistDirsTree user [
      (ls "flatpak")  # XDG Desktop Portal
    ];
  };
}
