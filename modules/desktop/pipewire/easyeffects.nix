{
  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "easyeffects")
    ];

  homeModule = { ... }: {
    services.easyeffects.enable = true;
  };
}
