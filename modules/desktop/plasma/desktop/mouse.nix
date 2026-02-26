{ ... }:
let
  _ = "ActionPlugins/0";
  _btn = x: "${x}Button;NoModifier";

  btnBack = _btn "Back";
  btnFwd = _btn "Forward";
  btnMid = _btn "Middle";
  btnRight = _btn "Right";
in {
  utils.kconfig.appletsrc.content = {
    # Button Functions
    "${_}" = {
      "${btnBack}" = "org.kde.switchdesktop";
      "${btnFwd}" = "switchwindow";
      "${btnMid}" = "org.kde.applauncher";
      "${btnRight}" = "org.kde.contextmenu";
    };

    # Back Button Options
    "${_}/${btnBack}".showAppsByName = true;

    # Forward Button Options
    "${_}/${btnFwd}".mode = 2;

    # Middle Button Options
    "${_}/${btnMid}".showAppsByName = false;

    # Right Button Options
    "${_}/${btnRight}" = {
      "_add panel" = false;
      "_context" = true;
      "_display_settings" = true;
      "_lock_screen" = true;
      "_logout" = true;
      "_open_terminal" = true;
      "_run_command" = false;
      "_sep1" = true;
      "_sep2" = true;
      "_sep3" = false;
      "_wallpaper" = true;
      "add widgets" = false;
      "configure" = true;
      "configure shortcuts" = false;
      "edit mode" = true;
      "manage activities" = false;
      "remove" = true;
      "run associated application" = false;
    };
  };
}
