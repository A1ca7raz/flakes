{
  homeModule = { pkgs, ... }: {
    home.packages = [
      pkgs.ayugram-desktop
    ];
  };

  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (ls "AyuGramDesktop")
    ];
}
