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
    device = "/dev/disk/by-id/nvme-ZHITAI_TiPlus7100_2TB_ZTA72T0AB253644904";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
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
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            settings = {
              allowDiscards = true;
#               keyFile = "/tmp/secret.key";
            };
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "NIX" = {
                  mountpoint = "/nix";
                  mountOptions = dataPartitionMountOptions;
                };
                "PERSIST" = {
                  mountpoint = "/nix/persist";
                  mountOptions = dataPartitionMountOptions;
                };
                "/swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "16G";
                };
              };
            };
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

  boot.initrd.luks.devices.crypted = {
    bypassWorkqueues = true;
    crypttabExtraOpts = [
      "fido2-device=auto"
      "same-cpu-crypt"
      "submit-from-crypt-cpus"
    ];
  };
}
