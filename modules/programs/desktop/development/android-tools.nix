{
  nixosModule = { pkgs, user, lib, ... }: {
    # Android-Tools
    programs.adb.enable = true;

    environment.persistence = lib.mkPersistDirsTree user [
      ".android"
    ];
  };

  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      scrcpy
    ];
  };
}

