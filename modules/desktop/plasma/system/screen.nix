{ user, ... }:
{
  utils.kconfig.kwinrc.content.Compositing = {
    WindowsBlockCompositing = false;
    LatencyPolicy = "ExtremelyHigh";
  };

  system.userActivationScripts.kwinconfigoutput = {
    text = ''
      [[ -L $HOME/.config/kwinoutputconfig.json ]] || \
      ln -sf $VERBOSE_ARG \
        /nix/persist/home/${user}/.config/kwinoutputconfig.json $HOME/.config/kwinoutputconfig.json
    '';
    deps = [];
  };
}
