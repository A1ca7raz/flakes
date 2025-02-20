{
  homeModule = { pkgs, config, lib, ... }: {
    home.packages = [
      ((pkgs.dmlive.override {
        mpv = config.lib.packages.mpv;
        ffmpeg = pkgs.ffmpeg_6;
        rustPlatform = pkgs.rustPlatform // {
          buildRustPackage = args: pkgs.rustPlatform.buildRustPackage (
            args // {
              version = "5.5.7";
              src = pkgs.fetchFromGitHub {
                owner = "THMonster";
                repo = "dmlive";
                rev = "79b4d9430fca3ebb86c57ee506989f620ea68a21"; # no tag
                hash = "sha256-0DDKKd4IZj+3AyVMG4FXjCbvvMg5iDCiF1B6nB8n3lU=";
              };
              cargoHash = "sha256-UwKQivYZyXYADbwf4VA1h2y7YzpxefUgDYQG+NaLMwE=";
            }
          );
        };
      }).overrideAttrs (p: {
        postInstall = ''
          wrapProgram "$out/bin/dmlive" --prefix PATH : "${
            lib.makeBinPath [
              # pkgs.mpv
              pkgs.ffmpeg_6
              pkgs.nodejs
            ]
          }"
          mkdir -p $out/share/applications
          echo '[Desktop Entry]' >> $out/share/applications/dmlive-mime.desktop
          echo 'Version=1.0' >> $out/share/applications/dmlive-mime.desktop
          echo 'Name=dmlive mime' >> $out/share/applications/dmlive-mime.desktop
          echo 'NoDisplay=true' >> $out/share/applications/dmlive-mime.desktop
          echo 'Exec=dmlive -u %u --quiet' >> $out/share/applications/dmlive-mime.desktop
          echo 'Icon=revda' >> $out/share/applications/dmlive-mime.desktop
          echo 'Type=Application' >> $out/share/applications/dmlive-mime.desktop
          echo 'MimeType=x-scheme-handler/dmlive;' >> $out/share/applications/dmlive-mime.desktop
        '';
      }))
    ];

    xdg.mimeApps.associations.added."x-scheme-handler/dmlive" = "dmlive-mime.desktop";
  };
}
