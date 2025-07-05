{
  homeModule = { lib, ... }: {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  nixosModule = { user, lib, pkgs, ... }: with lib; {
    environment.persistence = mkPersistDirsTree user [
      (c "direnv") (ls "direnv")
    ];

    system.activationScripts.cleanDirenv = ''
      function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }
      if [[ -e /run/current-system ]] && version_gt $(cat $systemConfig/nixos-version) $(cat /run/current-system/nixos-version); then
        rm -v $(nix-store --gc --print-roots --quiet | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)" | egrep ".direnv" | egrep -v "^Removing" | cut -f1 -d' ')
      fi
    '';
  };
}
