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
    device = "/dev/disk/by-id/ata-Phison_SATA_SSD_64FC0795129E00079248";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          name = "ESP";
          start = "1M";
          end = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "noatime" "nodiratime" "discard" ];
          };
        };
        SYSTEM = {
          end = "-4G";
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

  disko.devices.disk.data = {
    type = "disk";
    device = "/dev/disk/by-id/ata-ST4000VX000-2AG166_ZDHAAYRB";
    content = {
      type = "btrfs";
      extraArgs = [ "-f" ];
      subvolumes = {
        DATA = {
          mountOptions = dataPartitionMountOptions;
          mountpoint = "/mnt/data";
        };
        MEDIA = {
          mountOptions = dataPartitionMountOptions;
          mountpoint = "/mnt/media";
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
