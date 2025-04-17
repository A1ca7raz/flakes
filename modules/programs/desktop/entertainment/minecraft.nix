{
  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (ls "PrismLauncher")
    ];

  homeModule = { pkgs, ... }: {
    home.packages = [ pkgs.prismlauncher ];
  };
}
