{
  homeModule = { pkgs, inputs, ... }: {
      home.packages = with pkgs; [
        spicetify
        sptlrx                      # Command-line Lyrics
        playerctl
      ];

      programs.fish.interactiveShellInit = ''
        sptlrx completion fish | source
      '';

      xdg.configFile.sptlrx = {
        target = "sptlrx/config.yaml";
        text = ''
          player: mpris
          timerInterval: 200
          updateInterval: 2000
          style:
            hAlignment: center
            before:
              background: ""
              foreground: "#c1c1c1"
              bold: true
              italic: false
              undeline: false
              strikethrough: false
              blink: false
              faint: false
            current:
              background: ""
              foreground: "#aaaaff"
              bold: false
              italic: false
              undeline: false
              strikethrough: false
              blink: false
              faint: true
            after:
              background: ""
              foreground: ""
              bold: false
              italic: false
              undeline: false
              strikethrough: false
              blink: false
              faint: false
          pipe:
            length: 0
            overflow: ellipsis
            ignoreErrors: true
          mpris:
            players: [ 'spotify', 'spotifyd' ]
        '';
      };
    };

  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "spotify")
    ];
}
