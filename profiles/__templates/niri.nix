{ self, ... }:
{
  imports = [
    ./desktop.nix
  ];

  modules = with self.modules; [
    desktop.greetd
    desktop.niri
    desktop.noctalia
    desktop.theme
    desktop.wayland

    system.security.gnome-keyring
    system.security.polkit
  ];
}
