{ config, ... }:
let
  inherit (config.lib.plasma) activityId;
in {
  lib.plasma.activityId = "114514aa-bbcc-ddee-ff00-1919810abcde";

  # No Baloo
  utils.kconfig.kactivitymanagerdrc.content.Plugins."org.kde.ActivityManager.ResourceScoringEnabled" = false;
  utils.kconfig.kactivitymanagerd-pluginsrc.content."Plugin-org.kde.ActivityManager.Resources.Scoring".what-to-remember = 1;
  utils.kconfig.baloofilerc.content."Basic Settings".Indexing-Enabled = false;

  # KActivity
  utils.kconfig.kactivitymanagerdrc.content.activities.${activityId} = "Default";
  utils.kconfig.kactivitymanagerdrc.content.main.currentActivity = activityId;
}
