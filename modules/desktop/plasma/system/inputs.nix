{ ... }:
{
  ## Mouses
  utils.kconfig.kcminputrc.content = {
    Keyboard.NumLock = 0;
    Mouse.XLbInptAccelProfileFlat = true;

    "Libinput/1739/52781/MSFT0004:00 06CB:CE2D Touchpad" = {
      ClickMethod = 2;
      NaturalScroll = true;
      TapToClick = true;
    };

    # My mouses
    "Libinput/1133/16505/Logitech G Pro ".PointerAccelerationProfile = 1;
    "Libinput/1133/16500/Logitech G304".PointerAccelerationProfile = 1;
  };

  ## Wayland Virtual Keyboard
  utils.kconfig.kwinrc.content.Wayland.InputMethod = {
    value = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
    shellExpand = true;
  };

  ## Touchpad
  utils.kconfig.touchpadxlibinputrc.content."MSFT0004:00 06CB:CE2D Touchpad" = {
    clickMethodAreas = false;
    clickMethodClickfinger = true;
    disableWhileTyping = false;
    lmrTapButtonMap = false;
    lrmTapButtonMap = true;
    middleEmulation = false;
    pointerAcceleration = "-0.1";
    pointerAccelerationProfileAdaptive = true;
    pointerAccelerationProfileFlat = false;
    tapToClick = true;
  };
}
