{ ... }:
let
  tuneOptions = [
    "noatime"
    "nodiratime"
    "compress=zstd"
  ];
in {
  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "defaults" "size=1G" "mode=755" "nosuid" "nodev" ];
  };

  # mSATA
  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/BOOT";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/SYS";
    fsType = "btrfs";
    options = [ "subvol=/NIX" ] ++ tuneOptions;
  };

  # SSD
  fileSystems."/nix/persist" = {
    device = "/dev/disk/by-partlabel/PERSIST";
    fsType = "btrfs";
    options = [ "subvol=/PERSIST" ] ++ tuneOptions;
    neededForBoot = true;
  };

  # NOTE: DATA Drive
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/DATA";
    fsType = "btrfs";
    options = [ "subvol=/DATA" ] ++ tuneOptions;
    neededForBoot = true;
  };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-label/DATA";
    fsType = "btrfs";
    options = [ "subvol=/MEDIA" ] ++ tuneOptions;
    neededForBoot = true;
  };

  fileSystems."/var/lib/immich" = {
    device = "/mnt/data/immich";
    depends = [ "/mnt/data" ];
    fsType = "none";
    options = [ "bind" ];
  };
}
