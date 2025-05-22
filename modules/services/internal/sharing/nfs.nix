{ config, ... }:
{
  services.nfs.server = {
    enable = true;
    exports = ''
      /media 192.168.0.0/16(rw,insecure,async,all_squash,no_subtree_check,anonuid=1000,anongid=${toString config.users.groups.media.gid})
    '';
  };

  systemd.services.nfs-mountd.serviceConfig.BindPaths = [
    "/mnt/media:/media"
  ];
}
