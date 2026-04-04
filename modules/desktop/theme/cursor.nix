{ home, pkgs, ... }:
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    dotIcons.enable = false;
    gtk.enable = true;
  };
}
