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
  # fileSystems."/mnt/data/0" = {
  #   device = "/dev/disk/by-label/DATA0";
  #   fsType = "btrfs";
  #   options = [ "subvol=/DATA0" ] ++ tuneOptions;
  #   neededForBoot = true;
  # };
  # fileSystems."/mnt/data/1" = {
  #   device = "/dev/disk/by-label/DATA0";
  #   fsType = "btrfs";
  #   options = [ "subvol=/DATA1" ] ++ tuneOptions;
  #   neededForBoot = true;
  # };

  # fileSystems."/var/lib/ocis/storage/" = {
  #   device = "/mnt/data/1/ocis_storage";
  #   depends = [ "/mnt/data/1" ];
  #   fsType = "none";
  #   options = [ "bind" ];
  # };
}
