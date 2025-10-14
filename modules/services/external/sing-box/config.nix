{ config, secrets, const, ... }:
let
  enc_singbox = { path = secrets.services.sing-box; };
  enc_host = { path = secrets.hosts.${const.node.profileName}; };

  dec = entry: { _secret = config.sops.secrets."${entry}".path; };
in {
  utils.secrets = {
    "inbounds/hysteria2/port" = enc_singbox;
    "inbounds/hysteria2/hopping_ports" = enc_singbox;
    "inbounds/hysteria2/secrets" = enc_singbox;
    "host/proxy/sni" = enc_host;
    "host/proxy/email" = enc_host;
  };

  services.sing-box.settings.inbounds = [
    {
      type = "hysteria2";
      listen  = "::";
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

  sops.templates.hysteria2-porthopping.content = ''
    chain prerouting {
      type nat hook prerouting priority dstnat; policy accept;
      iifname eth0 udp dport ${config.sops.placeholder."inbounds/hysteria2/hopping_ports"} counter redirect to :${config.sops.placeholder."inbounds/hysteria2/port"}
    }
  '';

  networking.nftables.tables.hysteria2-porthopping = {
    family = "inet";
    content = ''
      include "${config.sops.templates.hysteria2-porthopping.path}"
    '';
  };

  networking.nftables.checkRuleset = false;
}
