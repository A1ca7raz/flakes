{
  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "easyeffects")
      (ls "easyeffects")
    ];

  homeModule = { ... }: {
    services.easyeffects.enable = true;
  };
}
