{ home, pkgs, ... }:
{
  home.packages = [ pkgs.kdePackages.kompare ];
}
