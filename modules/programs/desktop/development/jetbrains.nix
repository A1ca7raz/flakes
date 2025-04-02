{
  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
#       datagrip
      goland
    ];
  };

  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "JetBrains") (ls "JetBrains")
    ];
}
