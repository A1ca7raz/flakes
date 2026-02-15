{
  nixosModule = { pkgs, user, lib, ... }: {
    environment.persistence = lib.mkPersistDirsTree user [
      ".android"
    ];
  };

  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      android-tools
      scrcpy
    ];
  };
}

