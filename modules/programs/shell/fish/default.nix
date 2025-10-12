{ lib, ... }:
let
  inherit (lib) ls;
in {
  programs.fish = {
    enable = true;
    useBabelfish = true;

    interactiveShellInit = ''
      set -U fish_greeting
    '';
  };
}
