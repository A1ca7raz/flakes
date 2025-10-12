{ self, ... }:
let
  dataPartitionMountOptions = [
    "compress=zstd"
    "noatime"
    "nodiratime"
  ];
in {
  imports = [
    self.nixosModules.disko
  ];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/vda";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          priority = 1;
          size = "1M";
          type = "EF02"; # for grub MBR
          attributes = [ 0 ]; # partition attribute
        };
        ESP = {
          priority = 2;
          name = "ESP";
          size = "500M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "noatime" "nodiratime" "discard" ];
          };
        };
        SYSTEM = {
          end = "-2G";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "/nix" = {
                mountOptions = dataPartitionMountOptions;
                mountpoint = "/nix";
              };
              "/nix/persist" = {
                mountOptions = dataPartitionMountOptions;
                mountpoint = "/nix/persist";
              };
            };
          };
        };
        SWAP = {
          size = "100%";
          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true;
          };
        };
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "defaults"
      "size=2G"
      "mode=755"
      "nosuid"
      "nodev"
    ];
  };

  fileSystems."/nix/persist".neededForBoot = true;
}
