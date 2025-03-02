{
  kickOff = {
    plugin = "org.kde.plasma.kickoff";
    config.General = {
      compactMode = "true";
      favoritesDisplay = "1";
      favoritesPortedToKAstats = "true";
      icon = "distributor-logo-nixos";
      primaryActions = "3";
      showActionButtonCaptions = "false";
      systemFavorites = ''lock-screen\\,logout\\,save-session\\,switch-user\\,suspend\\,hibernate\\,reboot\\,shutdown'';
    };
  };

  iconTasks = {
    plugin = "org.kde.plasma.icontasks";
    config.General = {
      iconSpacing = "3";
      launchers = builtins.concatStringsSep "," [
        "preferred://filemanager"
        "preferred://browser"
        "applications:codium.desktop"
        "applications:spotify.desktop"
        "applications:org.telegram.desktop.desktop"
        "applications:systemsettings.desktop"
      ];
      showOnlyCurrentScreen = "true";
    };
  };
}
