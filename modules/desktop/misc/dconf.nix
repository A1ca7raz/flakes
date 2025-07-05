{ user, lib, ... }:
with lib; mkPersistDirsModule user [
  (c "dconf")
]
