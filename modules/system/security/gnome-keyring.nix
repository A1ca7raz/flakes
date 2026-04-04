{ user, lib, ... }:
{
  services.gnome.gnome-keyring.enable = true;

  environment.persistence = lib.mkPersistDirsTree user [
    (lib.ls "keyrings")
  ];
}
