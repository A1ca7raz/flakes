{
  homeModule = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.override {
        commandLineArgs = builtins.concatStringsSep " " [
          "--extensions-dir ~/.local/share/VSCodium/extensions"
          "--password-store=gnome-libsecret"
        ];
      };
    };

    xdg.mimeApps.associations.added."inode/directory" = "codium-url-handler.desktop";
  };


  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "VSCodium")
      (ls "VSCodium")
    ];
}
