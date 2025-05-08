{ config, secrets, const, ... }:
let
  enabled = { u2fAuth = true; };
in {
  utils.secrets."host/fido_token".path = secrets.hosts.${const.node.profileName};

  security.pam = {
    u2f.enable = true;
    u2f.settings = {
      cue = true;
      authfile = config.sops.secrets."host/fido_token".path;
    };

    services = {
      login = enabled;
      sudo = enabled;
      polkit-1 = enabled;
      kde = enabled;
    };
  };
}
