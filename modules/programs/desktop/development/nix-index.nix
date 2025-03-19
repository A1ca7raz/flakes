{ self, ... }:
{
  imports = [
    self.nixosModules.nix-index
  ];
}
