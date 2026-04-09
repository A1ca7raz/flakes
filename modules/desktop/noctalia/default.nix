{
  homeModule = { pkgs, inputs, lib, ... }: {
    imports = [
      inputs.pkgs.homeModules.noctalia
    ];

    programs.noctalia-shell = {
      enable = true;
      package = pkgs.noctalia-nighty;
      settings = lib.mkDefault (with builtins; fromJSON (readFile ./config.json));
      plugins = lib.mkDefault (with builtins; fromJSON (readFile ./plugins.json));
      systemd.enable = true;
    };
  };

  nixosModule = { lib, user, ... }: {
    environment.persistence = lib.mkPersistDirsTree user [
      (lib.c "noctalia/plugins")
    ];

    services.gnome.evolution-data-server.enable = true; # TODO: Persistence?
  };
}
