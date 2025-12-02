{
  nixosModule = { config, lib, ... }: {
    utils.kconfig.kwinrc.content = {
      Plugins = {
        blurEnabled = false;
        forceblurEnabled = true;
        contrastEnabled = true;
        dynamic_workspacesEnabled = true;
        kwin4_effect_eyeonscreenEnabled = true;
        kwin4_effect_windowapertureEnabled = false;
        kwin4_effect_dimscreenEnabled = true;
        kwin4_effect_geometry_changeEnabled = true;
        minimizeallEnabled = true;
        synchronizeskipswitcherEnabled = true;
        unmaxorminEnabled = true;
      };

      Effect-blurplus = {
        BlurMatching = false;
        BlurNonMatching = true;
        BlurStrength = 8;
        PaintAsTranslucent = true;
        TransparentBlur = false;
        WindowClasses = "";
        BlurDecorations = true;
      };

      Effect-kwin4_effect_scale = {
        InScale = 0.3;
        OutScale = 0.3;
      };

      Effect-slide = {
        HorizontalGap = 0;
        VerticalGap = 0;
        SlideDocks = true;
      };

      Effect-windowview.BorderActivateClass = 7;
      Effect-overview.BorderActivate = 1;
      Script-minimizeall.BorderActivate = 3;

      Windows = {
        DelayFocusInterval = 0;
        ActivationDesktopPolicy = "BringToCurrentDesktop";
      };

      MouseBindings = {
        CommandTitlebarWheel = "Maximize/Restore";
        CommandActiveTitlebar2 = "Close";
        CommandInactiveTitlebar2 = "Close";
      };

      TabBox = {
        HighlightWindows = false;
        LayoutName = "thumbnail_grid";
        ShowDesktopMode = 1;
        ApplicationsMode = 1;
        OrderMinimizedMode = 1;
      };

      TabBoxAlternative = {
        HighlightWindows = false;
        ShowTabBox = false;
      };
    };

    utils.kconfig.kdeglobals.content = {
      General = {
        accentColorFromWallpaper = true;
        AllowKDEAppsToRememberWindowPositions = false;
      };

      KDE = {
        SingleClick = false;
        ScrollbarLeftClickNavigatesByPage = true;
      };
    };

    utils.kconfig.kscreenlockerrc.content = {
      Daemon.Autolock = false;
      Greeter.WallpaperPlugin = "org.kde.potd";

      "Greeter/Wallpaper/org.kde.potd/General" = {
        Provider = "bing";
        UpdateOverMeteredConnection = 1;
      };
    };
  };

  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      kwin-effects-forceblur
      kwin-effects-geometry-change
    ];
  };
}
