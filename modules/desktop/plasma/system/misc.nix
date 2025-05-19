{ ... }:
let
  disableModules = builtins.foldl'
    (acc: x:
      acc // { "Module-${x}".autoload = false; }
    )
    {};
in {
  ## KDE Daemon
  utils.kconfig.kded5rc.content = disableModules [
    "baloosearchmodule"
    "browserintegrationreminder"
    "colorcorrectlocationupdater"
    "device_automounter"
    "donationmessage"
    "freespacenotifier"
    "kded_accounts"
    "kded_bolt"
    "plasmavault"
    "proxyscout"
  ];

  ## Session
  utils.kconfig.ksmserverrc.content.General.loginMode = "emptySession";

  ## Notifications
  utils.kconfig.plasmanotifyrc.content.Notifications.PopupPosition = "TopRight";

  ## Misc
  utils.kconfig.kaccessrc.content.ScreenReader.Enabled = false;
  utils.kconfig.kwalletrc.content.Wallet."First Use" = false;

  ## Shakecursor
  utils.kconfig.kdeglobals.content.Effect-shakecursor.Magnification = 2;
}
