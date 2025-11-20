{ config, ... }:
{
  services.samba = {
    enable = true;

    settings = {
      global = {
        "use sendfile" = "yes";
      };
    };

    settings.media = {
      browseable = "yes";
      path = "/mnt/media";
      "guest ok" = "yes";
      writable = "yes";
    };
  };

  users.users.samba = {
    group = "media";
    description = "User for samba clients";
    isSystemUser = true;
  };
}
