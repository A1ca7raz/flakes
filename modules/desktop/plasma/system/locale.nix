{ ... }:
{
  utils.kconfig = {
    plasma-localerc.content = {
      Formats.LANG = "zh_CN.UTF-8";
      Translations.LANGUAGE = "zh_CN:en_US";
    };

    ktimezonedrc.content.ktimezonedrc = {
      LocalZone = "Asia/Shanghai";
      ZoneinfoDir = "/usr/share/zoneinfo";
      Zonetab = "/usr/share/zoneinfo/zone.tab";
    };

    plasma_calendar_alternatecalendar.content.General = {
      calendarSystem = "Chinese";
      dateOffset = 0;
    };

    plasma_calendar_holiday_regions.content.General.selectedRegions = "cn_zh-cn";
  };
}
