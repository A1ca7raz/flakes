{ home, ... }:
# /etc/profiles/per-user/nomad/share/applications/
let
  # Inline Functions
  mkApp = x: "${x}.desktop";

  # Normal Apps
  kate = mkApp "org.kde.kate";
  vsc = mkApp "codium";                          # VSCode (VSCodium)
  firefox = mkApp "firefox";
  mpv = mkApp "mpv";
in {
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/markdown" = [ kate vsc ];
      "application/x-zerosize" = [ kate ];
    };

    defaultApplications = {
      "text/plain" = kate;
      "video/mp4" = mpv;
      "application/pdf" = firefox;
      "application/x-zerosize" = kate;
    };
  };
}
