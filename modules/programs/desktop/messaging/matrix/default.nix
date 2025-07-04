{
  homeModule = { pkgs, ... }: {
    home.packages = with pkgs; [
      element-desktop
      fractal
    ];
  };

  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "Element")
      (ls "fractal")
    ];
}
