{
  lib,
  stdenv
}:
stdenv.mkDerivation {
  pname = "kde-desktop-theme";
  version = "1.0.0";

  src = ./src;

  installPhase = ''
    mkdir -p $out/share/Kvantum
    mkdir -p $out/share/color-schemes
    mkdir -p $out/share/plasma/desktoptheme
    mkdir -p $out/share/plasma/look-and-feel

    [[ -d $src/kvantum ]] && cp -r $src/kvantum/* $out/share/Kvantum || true
    [[ -d $src/color-schemes ]] && cp -r $src/color-schemes/* $out/share/color-schemes || true
    [[ -d $src/desktoptheme ]] && cp -r $src/desktoptheme/* $out/share/plasma/desktoptheme || true
    [[ -d $src/look-and-feel ]] && cp -r $src/look-and-feel/* $out/share/plasma/look-and-feel || true
  '';
}
