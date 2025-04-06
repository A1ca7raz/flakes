rec {
  windowButtons = {
    plugin = "org.kde.windowbuttons";
    config.General = {
      containmentType = "Plasma";
      filterByScreen = "false";
      hiddenState = "EmptySpace";
      inactiveStateEnabled = "true";
      lengthFirstMargin = "5";
      lengthLastMargin = "5";
      selectedScheme = "/etc/profiles/per-user/nomad/share/color-schemes/KvArc.colors";
      useCurrentDecoration = "false";
      visibility = "3";
    };
  };

  windowAppMenu.plugin = "org.kde.plasma.appmenu";

  panelSpacer.plugin = "org.kde.plasma.panelspacer";

  spacerExtended = {
    plugin = "luisbocanegra.panelspacer.extended";
    config.General = {
      middleClickAction = "kwin,Window Close";
      mouseWheelDownAction = "kwin,Window Unmaximize Or Minimize";
      mouseWheelUpAction = "kwin,Window Maximize";
      pressHoldAction = "kwin,Overview";
      showHoverBg = "false";
      showTooltip = "false";
      singleClickAction = "Disabled,Disable";
    };
  };

  space = length: {
    plugin = "org.kde.plasma.panelspacer";
    config.General = {
      expanding = "false";
      length = length;
    };
  };

  space5 = space 5;

  systemTray = containmentId: {
    plugin = "org.kde.plasma.systemtray";
    config._ = {
      PreloadWeight = "60";
      SystrayContainmentId = containmentId;
    };
  };

  lockLogout = {
    plugin = "org.kde.plasma.lock_logout";
    config.General.show_lockScreen = "false";
  };

  digitalClock = {
    plugin = "org.kde.plasma.digitalclock";
    config.Appearance = {
      customDateFormat = ''yyyy.M.d ddd'';
      dateDisplayFormat = "BesideTime";
      dateFormat = "custom";
      fixedFont = "true";
      fontFamily = "Source Han Sans SC";
      fontWeight = "400";
      showSeconds = "2";
      showSeparator = "false";
      use24hFormat = "0";
    };
  };

  kara = {
    plugin = "org.dhruv8sh.kara";
    config = {
      general = {   # NOTE: not G
        animationDuration = "180";
        spacing = "4";
        type = "0";
      };
      type1 = {
        t1activeHeight = "6";
        t1activeWidth = "18";
        t1height = "4";
        t1width = "8";
      };
    };
  };

  plasmusicToolbar = {
    plugin = "plasmusic-toolbar";
    config.General = {
      albumCoverRadius = "25";
      choosePlayerAutomatically = "false";
      commandsInPanel = "false";
      fallbackToIconWhenArtNotAvailable = "true";
      maxSongWidthInPanel = "180";
      preferredPlayerIdentity = "Spotify";
      textScrollingBehaviour = "2";
      textScrollingSpeed = "2";
      useAlbumCoverAsPanelIcon = "true";
    };
  };

  betterWindowTitle = {
    plugin = "plasma6-window-title-applet";
    config = {
      Appearance = {
        altTxt = "";
        fillThickness = "true";
        fixedLength = "200";
        fontSize = "13";
        isBold = "true";
        lengthKind = "2";
        midSpace = "4";
        txt = "%a";
      };
      Behavior = { filterByScreen = "true"; };
      Substitutions = {
        subsMatchApp = builtins.concatStringsSep "," [
          ''"Telegram Desktop"''
          ''"AyuGram Desktop"''
          ''"Gimp-.*"''
          ''"soffice.bin"''
          ''"Spotify.*"''
          ''"Kate.*"''
          ''"Dolphin .*"''
          ''"Thunderbird .*"''
          ''"Konsole .*"''
          ''"IntelliJ IDEA Ultimate Edition"''
          ''"Pycharm Professional Edition"''
          ''"VSCodium - URL Handler"''
        ];
        subsMatchTitle = builtins.concatStringsSep "," [
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
          ''".*"''
        ];
        subsReplace = builtins.concatStringsSep "," [
          ''"Telegram"''
          ''"AyuGram"''
          ''"Gimp"''
          ''"LibreOffice"''
          ''"Spotify"''
          ''"Kate"''
          ''"Dolphin"''
          ''"Thunderbird"''
          ''"Konsole"''
          ''"IDEA"''
          ''"Pycharm"''
          ''"VSCodium"''
        ];
      };
    };
  };
}
