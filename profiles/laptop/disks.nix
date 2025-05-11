{ ... }:
let
  tuneOptions = [
    "noatime"
    "nodiratime"
    "compress=zstd"
  ];

  mkRootMount = subvol: {
    device = "/dev/mapper/block";
    fsType = "btrfs";
    options = [ "subvol=/${subvol}" ] ++ tuneOptions;
  };
in {
  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" "nosuid" "nodev" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/BOOT";
    fsType = "vfat";
    options = ["noatime" "nodiratime" "discard"];
  };

  fileSystems."/swap" = {
    device = "/dev/mapper/block";
    fsType = "btrfs";
    options = [ "subvol=/SWAP" "noatime" "nodiratime" ];
  };

  fileSystems."/nix" = mkRootMount "NIX";

  fileSystems."/nix/persist" = mkRootMount "PERSIST" // { neededForBoot = true; };

  boot.initrd.luks.devices.block = {
    device = "/dev/disk/by-partlabel/ROOT";
    allowDiscards = true;
    bypassWorkqueues = true;
    crypttabExtraOpts = [
      "fido2-device=auto"
      "same-cpu-crypt"
      "submit-from-crypt-cpus"
    ];
  };
}
