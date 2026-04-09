{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    fira-code-symbols
    font-awesome

    liberation_ttf
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    sarasa-gothic
    source-code-pro
    source-han-mono
    source-han-sans
    source-han-serif
    wqy_microhei

    nerd-fonts.caskaydia-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
  ];
}
