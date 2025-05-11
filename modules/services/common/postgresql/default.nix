{ pkgs, ... }:
{
  imports = [
    ./netns.nix
  ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17_jit;
    initdbArgs = [ "--locale=zh_CN.UTF-8" "-E UTF8" "--data-checksums" ];

    settings = {
      allow_alter_system = false;
    };

    enableJIT = true;
  };
}
