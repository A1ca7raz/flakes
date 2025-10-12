{ ... }:
let
  swap = "/dev/disk/by-partlabel/SWAP";
in {
  swapDevices = [
    { device = swap; }
  ];

  boot.resumeDevice = swap;
}
