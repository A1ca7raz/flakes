{ variables, pkgs, ... }:
let
  inherit (variables.services.moviepilot)
    ip
    domain
  ;

  backendHost = "127.10.3.24";
  backendPort = "23122";
  backend = "http://${backendHost}:${backendPort}";
in {
  systemd.services.moviepilot.environment = {
    HOST = backendHost;
    PORT = backendPort;
  };

  systemd.services.moviepilot = {
    after = [ "netns-veth-proxyh.service" ];
    bindsTo = [ "netns-veth-proxyh.service" ];
    serviceConfig.NetworkNamespacePath = [ "/run/netns/proxy" ];
  };

  services.caddy.virtualHosts.moviepilot = {
    hostName = domain;
    listenAddresses = [ ip ];
    serverAliases = [];

    # TODO: 修反代，api 代理失败
    extraConfig = ''
      # 公共根目录
      root * ${pkgs.moviepilot.frontend}
      file_server

      # 主应用路由
      handle /* {
        # 禁用缓存
        header {
          Cache-Control "no-cache, no-store, must-revalidate"
        }
        try_files {path} {path}/ /index.html
      }

      # 图片类静态资源
      @image {
        path *.png|*.jpg|*.jpeg|*.gif|*.ico|*.svg
      }
      handle @image {
        header {
          Cache-Control "public, immutable"
          Expires "1y"
        }
      }

      # assets目录
      handle /assets/* {
        header {
          Cache-Control "public, immutable"
          Expires "1y"
        }
      }

      # 本地CookieCloud
      handle /cookiecloud/* {
        rewrite * {path}
        reverse_proxy ${backend} {
          header_up X-Real-IP {remote_host}
          header_up Host {http_host}
          header_up X-Nginx-Proxy "true"
        }
        header -Cache-Control
      }

      # SSE特殊配置
      @sse {
        path /api/v1/system/message/*|/api/v1/system/progress/*
      }
      handle @sse {
        header {
          Cache-Control no-cache
          X-Accel-Buffering no
          Content-Type text/event-stream
        }
        reverse_proxy ${backend} {
          header_up X-Real-IP {remote_host}
          header_up Host {http_host}
          flush_interval -1
        }
      }

      # API代理配置
      handle /api/* {
        rewrite * {path}
        reverse_proxy ${backend} {
          header_up X-Real-IP {remote_host}
          header_up Host {http_host}
          header_up X-Nginx-Proxy "true"
        }
      }
    '';
  };
}
