{
  nixosModule = { user, lib, ... }:
    let
      inherit (lib) ls;
    in {
      environment.persistence."/nix/persist" =
        if user == "root"
        then {
          directories = [ "/root/${ls "fish"}" ];
        } else {
          users.${user}.directories = [
            (ls "fish")
          ];
        };
    };

  homeModule = { pkgs, ... }:
    let
      tide = pkgs.fishPlugins.tide.src;
      source = f: builtins.readFile ./config/${f}.fish;
    in {
      programs.fish = {
        enable = true;
        plugins = [{
          name = "tide";
          src = tide;
        }];

        interactiveShellInit = ''
          # direnv hook fish | source
          ${source "fish"}

          # FIXME: Try to disable tide on TTY
          # TODO: 桌面美化
          if test "$TERM" != "linux"
            string replace -r '^' 'set -U ' < ${tide}/functions/tide/configure/configs/lean.fish         | source
            string replace -r '^' 'set -U ' < ${tide}/functions/tide/configure/configs/lean_16color.fish | source
            ${source "tide"}
          end
        '';
      };
    };
}
