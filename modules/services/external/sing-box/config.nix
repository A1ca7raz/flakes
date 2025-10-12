{ config, secrets, const, ... }:
let
  enc_singbox = { path = secrets.services.sing-box; };
  enc_host = { path = secrets.hosts.${const.node.profileName}; };

  dec = entry: { _secret = config.sops.secrets."${entry}".path; };
in {
  utils.secrets = {
    "inbounds/hysteria2/port" = enc_singbox;
    "inbounds/hysteria2/secrets" = enc_singbox;
    "host/proxy/sni" = enc_host;
    "host/proxy/email" = enc_host;
  };

  services.sing-box.settings.inbounds = [
    {
      type = "hysteria2";
      bind_interface = "eth0";
      listen_port = dec "inbounds/hysteria2/port" // { quote = false; };  # Integer
      users = dec "inbounds/hysteria2/secrets" // { quote = false; };     # Array
      tls = {
        alpn = [ "h3" ];
        enabled = true;
        server_name = dec "host/proxy/sni";
        acme = {
          domain = dec "host/proxy/sni";
          email = dec "host/proxy/email";
        };
      };
    }
  ];
}
