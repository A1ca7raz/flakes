{ user, lib, ... }:
let
  inherit (lib)
    ls
  ;
in {
  programs.fish = {
    enable = true;
    useBabelfish = true;

    interactiveShellInit = ''
      set -U fish_greeting
    '';
  };

  environment.persistence."/nix/persist" =
    if user == "root"
    then {
      directories = [ "/root/${ls "fish"}" ];
    } else {
      users.${user}.directories = [
        (ls "fish")
      ];
    };
}
