{
  lib,
  config,
  ...
}: let
  cfg = config.servicesProfiles.adguardhome;
  inherit (lib) mkEnableOption mkOption types;
in {
  options.servicesProfiles.adguardhome = {
    enable = mkEnableOption "AdGuard Home profile";
    rewrites = mkOption {
      type = types.listOf (types.submodule (_: {
        options = {
          domain = mkOption {
            type = types.str;
            description = "Domain to rewrite";
          };
          answer = mkOption {
            type = types.str;
            description = "Rewrite answer (IP or hostname)";
          };
        };
      }));
      default = [];
      description = "List of DNS rewrite rules for AdGuard Home.";
      example = [
        {
          domain = "nas.local";
          answer = "192.168.1.10";
        }
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
      # Bind the admin web UI away from :80 so Caddy can use it
      host = "127.0.0.1";
      port = 3000;
      settings = {
        dns = {
          upstream_dns = ["127.0.0.1:5353"];
          bootstrap_dns = ["1.1.1.1" "8.8.8.8"];
          inherit (cfg) rewrites;
        };
      };
    };
  };
}
