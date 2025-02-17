{
  nixosModule = { user, lib, ... }:
    with lib; mkPersistDirsModule user [ ".ssh" ];

  homeModule = { const, ... }: {
    programs.ssh = {
      enable = true;
      includes = [
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/AOSC-Dev/Buildbots/main/ssh_config";
          sha256 = "sha256:1flsvq3890kl3w34n43v1wpq8f79la2x885w4mmsdkjw9wqfl8i2";
        })
      ];

      matchBlocks = {
        gh = {
          hostname = "github.com";
          user = "git";
        };
        gl = {
          hostname = "gitlab.com";
          user = "git";
        };
        "*.node" = {
          port = const.port.ssh;
        };
        archcn = {
          hostname = "build.archlinuxcn.org";
          user = "a1ca7raz";
        };
        "*.felixc.at" = {
          forwardAgent = true;
        };
      };
    };

    home.file.aosc-known-hosts = {
      source = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/AOSC-Dev/Buildbots/main/ssh_known_hosts";
        sha256 = "sha256:1vm7dxqjc3dpawcn9s0pvq85ilyfywnn63a2lai13v2v3jallhm8";
      };
      target = ".ssh/known_hosts.d/aosc";
    };
  };
}
