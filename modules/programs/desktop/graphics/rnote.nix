{ pkgs, home, ... }: {
  home.packages = with pkgs; [
    rnote
  ];
}
