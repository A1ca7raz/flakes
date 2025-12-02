{ ... }:
{
  imports = [
    ./proxy.nix
  ];

  services.sillytavern.enable = true;
}
