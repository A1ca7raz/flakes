{
  nixosModule = { lib, user, ... }:
    with lib; mkPersistDirsModule user [
      (c "rclone")
  ];

  homeModule = { pkgs, ... }:
    let
      mkRcloneService = { targetPath, sourcePath }:
        let
          mountPath = ".cache/rclone/${targetPath}";
          rcloneOptions = builtins.concatStringsSep " " [
            "--multi-thread-streams 64"
            "--multi-thread-cutoff 128M"
            "--vfs-cache-mode full"
            "--vfs-cache-max-size 100G"
            "--vfs-cache-max-age 6h"
            "--vfs-read-chunk-size-limit off"
            "--buffer-size 128M"
            "--vfs-read-chunk-size 128M"
            "--vfs-read-wait 0ms"
            "--allow-non-empty"
          ];
        in {
          Unit = {
            Description = "Rclone Daemon Auto mount";
            After = [ "sops-nix.service" "network-online.target" ];
          };
          Service = {
            ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${mountPath}";
            ExecStart = "${pkgs.rclone}/bin/rclone mount ${sourcePath} ${mountPath} ${rcloneOptions} --cache-dir \".cache/rclone/cache/${targetPath}\"";
            ExecStop = "${pkgs.util-linux}/bin/umount ${mountPath}";
            # https://discourse.nixos.org/t/fusermount-systemd-service-in-home-manager/5157
            Environment = "PATH=/run/wrappers/bin/:$PATH";
          };
          Install.WantedBy = [ "default.target" ];
        };
    in {
      home.packages = [ pkgs.rclone ];

      systemd.user.services = {
        rclone_fm_secure = mkRcloneService {
          sourcePath = "fm_secure:";
          targetPath = "fm_secure";
        };

        rclone_onedrive_e5 = mkRcloneService {
          sourcePath = "onedrive_e5:";
          targetPath = "onedrive_e5";
        };

        rclone_sharepoint_e5 = mkRcloneService {
          sourcePath = "sharepoint_e5:";
          targetPath = "sharepoint_e5";
        };
      };
    };
}
