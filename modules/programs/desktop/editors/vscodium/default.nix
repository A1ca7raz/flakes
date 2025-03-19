{
  homeModule = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.override {
        commandLineArgs = "--extensions-dir ~/.local/share/VSCodium/extensions";
      };
    };

    xdg.mimeApps = {
      associations.added."inode/directory" = "codium.desktop";
      defaultApplications."inode/directory" = "codium.desktop";
    };
  };


  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [
      (c "VSCodium")
      (ls "VSCodium")
    ];
}
