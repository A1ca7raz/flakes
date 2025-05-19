{ lib, ... }:
let
  inherit (lib)
    foldl
    imap0
    mkItem
    convertItemsToKconfig
  ;

  mkException = id: attr: {
    "Windeco Exception ${toString id}" = attr;
  };

  mkExceptions = apps:
    foldl (acc: app: acc // app) {} (
      imap0 (i: v: mkException i {
        BorderSize = 2;
        DrawBackgroundGradient = false;
        DrawTitleBarSeparator = false;
        Enabled = true;
        ExceptionPattern = v;
        ExceptionType = 0;
        GradientOverride = -1;
        HideTitleBar = 3;
        IsDialog = false;
        Mask = 0;
        MatchColorForTitleBar = true;
        OpacityOverride = -1;
        OpaqueTitleBar = false;
      }) apps
    );
in {
  utils.kconfig.sierrabreezeenhancedrc.content = (convertItemsToKconfig [
    (mkItem "Common" "ShadowSize" "ShadowSmall")
    (mkItem "Windeco" "BackgroundOpacity" "64")
    (mkItem "Windeco" "ButtonStyle" "sbeDarkAuroraeActive")
    (mkItem "Windeco" "DrawBackgroundGradient" "false")
    (mkItem "Windeco" "DrawTitleBarSeparator" "false")
    (mkItem "Windeco" "HideTitleBar" "MaximizedWindows")
    (mkItem "Windeco" "OpaqueTitleBar" "false")
    (mkItem "Windeco" "UnisonHovering" "false")
  ]) // (mkExceptions [
    "steam$"
    "^et"
    "^wps"
    "^wpp"
    "^pdf"
    "^wpsoffice"
  ]);
}
