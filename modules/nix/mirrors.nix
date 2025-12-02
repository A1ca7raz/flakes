{ ... }:
let
  mkMirror = x: "https://${x}/nix-channels/store?priority=10";
  mkEduMirror = x: mkMirror "mirrors.${x}.edu.cn";
in {
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    (mkEduMirror "ustc")
    (mkEduMirror "bfsu")
#     (mkEduMirror "sjtug.sjtu")
#     (mkEduMirror "nju")
  ];

  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
}
