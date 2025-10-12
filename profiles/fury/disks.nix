{ ... }:
let
  dataPartitionMountOptions = [
    "compress=zstd"
    "noatime"
    "nodiratime"
  ];
in {
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
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
              "/nix/persist".mountOptions = dataPartitionMountOptions;
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
    type = "btrfs";
    device = "/dev/sdb";
    extraArgs = [ "-f" ];
    subvolumes = {
      DATA = {
        mountOptions = dataPartitionMountOptions;
        mountpoint = "/mnt/data";
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
}
