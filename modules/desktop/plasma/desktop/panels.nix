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
  wrapDock = {
    id,
    lastScreen,
    appletBaseId
  }: mkDock {
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

  wrapTopbar = {
    id,
    lastScreen,
    appletBaseId,
    trayId,
    spacerLen
  }: mkTopbar {
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
      spacerExtended
      colorizer
      digitalClock
      spacerExtended
      plasmusicToolbar
      (systemTray trayId)
      kara
      lockLogout
    ];
  };

  wrapTray = {
    id,
    lastScreen
  }: mkTray {
    General = {
      hiddenItems = builtins.concatStringsSep "," [
        "Xwayland 视频桥接程序_pipewireToXProxy"
        "KeePassXC"
        "steam"
        "birdtray"
        "org.kde.kscreen"
        "org.kde.kdeconnect"
        "org.kde.plasma.clipboard"
        "Easy Effects"
      ];
      scaleIconsToFit = true;
    };
  } id lastScreen;
in {
  utils.plasma.monitors = {
    main.panels = {
      topbar = wrapTopbar {
        id = 12;
        lastScreen = 0;
        appletBaseId = 100;
        trayId = 14;
        spacerLen = 26;
      };
      dock = wrapDock {
        id = 13;
        lastScreen = 0;
        appletBaseId = 200;
      };
      tray = wrapTray {
        id = 14;
        lastScreen = 0;
      };
    };

    secondary.panels = {
      topbar = wrapTopbar {
        id = 22;
        lastScreen = 1;
        appletBaseId = 300;
        trayId = 24;
        spacerLen = 22;
      };
      dock = wrapDock {
        id = 23;
        lastScreen = 1;
        appletBaseId = 400;
      };
      tray = wrapTray {
        id = 24;
        lastScreen = 1;
      };
    };
  };
}
