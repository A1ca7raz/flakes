{ lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.tuigreet} --time --cmd niri-session";
    };
  };
}
