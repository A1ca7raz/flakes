{ lib, ... }:
let
  inherit (import ./lib/panel.nix lib)
    mkTopbar
    mkDock
    mkTray
  ;

  topbarApplets = import ./applets/topbar.nix;
  dockApplets = import ./applets/dock.nix;

  # wrapColorizer = ;
  wrapDock = id: lastScreen: appletBaseId: mkDock {
    inherit id lastScreen appletBaseId;

    config = {
      _ = {
        alignment = 1;
        floating = 1;
        panelLengthMode = 1;
        panelOpacity = 2;
        panelVisibility = 1;
      };

      Defaults.thickness = 50;
    };

    applets = with dockApplets; [
      kickOff
      # colorizer
      iconTasks
    ];
  };

  wrapTopbar = id: lastScreen: appletBaseId: trayId: spacerLen: mkTopbar {
    inherit id lastScreen appletBaseId;

    config = {
      _ = {
        alignment = 132;
        floating = 1;
        panelOpacity = 2;
      };

      Defaults.thickness = spacerLen;
    };

    applets = with topbarApplets; [
      windowButtons
      betterWindowTitle
      windowAppMenu
      (space spacerLen)
      spacerExtended
      (space spacerLen)
      digitalClock
      (space spacerLen)
      spacerExtended
      plasmusicToolbar
      space5
      (systemTray trayId)
      space5
      kara
      lockLogout
    ];
  };

  wrapTray = mkTray {
    General = {
      hiddenItems = builtins.concatStringsSep "," [
        "Xwayland 视频桥接程序_pipewireToXProxy"
        "KeePassXC"
        "steam"
        "birdtray"
        "org.kde.kscreen"
        "org.kde.kdeconnect"
        "org.kde.plasma.clipboard"
      ];
      scaleIconsToFit = true;
    };
  };
in {
  utils.plasma.monitors = {
    main.panels = {
      topbar = wrapTopbar 12 0 100 14 26;
      dock = wrapDock 13 0 200;
      tray = wrapTray 14 0;
    };

    secondary.panels = {
      topbar = wrapTopbar 22 1 300 24 22;
      dock = wrapDock 23 1 400;
      tray = wrapTray 24 1;
    };
  };
}
