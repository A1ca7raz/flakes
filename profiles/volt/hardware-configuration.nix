{ ... }:
{
  imports = [
    ./disks.nix
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
}
