{
  homeModule = { pkgs, config, lib, ... }: {
    home.packages = [
      pkgs.dmlive
    ];

    xdg.configFile.dmlive = {
      target = "dmlive/config.toml";
      text = ''
        cookies_from_browser = "chromium"
        font_scale = 0.7
        danmaku_speed = 20000
      '';
    };
  };
}
