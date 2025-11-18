{ ... }:
let
  offset = 533760;
in
{
  boot.resumeDevice = "/dev/mapper/crypted";
  boot.kernelParams = [
    "resume_offset=${builtins.toString offset}"
#     "acpi_rev_override=1"
#     "acpi_osi=Linux"
#     "mem_sleep_default=deep"
  ];
}
