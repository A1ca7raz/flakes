{
  nixosModule = { lib, user, ... }:
    with lib; mkPersistDirsModule user [
      (ls "atuin")
    ];

  homeModule = { ... }:
    let
      settings = import ./config.nix;
    in {
      programs.fish.interactiveShellInit = ''
        if test "$TERM" = "linux"
          # bind UP on TTY mode
          bind up _atuin_bind_up
          bind -M insert up _atuin_bind_up
        else
          # bind Ctrl+UP on PTS mode
          bind ctrl-up _atuin_bind_up
          bind -M insert ctrl-up _atuin_bind_up
        end
      '';

      programs.atuin = {
        enable = true;
        settings = settings;
        flags = [
          "--disable-up-arrow"
        ];
      };
    };
}
