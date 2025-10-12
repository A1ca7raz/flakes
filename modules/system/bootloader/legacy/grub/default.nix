{ ... }:
{
  boot.loader.timeout = 2;
  boot.loader.grub = {
    enable = true;
    default = "saved";
    # devices = ["/dev/vda"];
  };
}
