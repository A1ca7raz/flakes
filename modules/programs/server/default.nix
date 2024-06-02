{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    efibootmgr
    e2fsprogs
    xfsprogs
  ];
}