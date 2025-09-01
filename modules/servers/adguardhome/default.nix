##
# Module: servers/adguardhome
# Purpose: AdGuardHome profile + DNS rewrite passthrough.
# Key options: cfg = config.servicesProfiles.adguardhome (enable, rewrites)
# Dependencies: May integrate with Unbound (upstream_dns).
{
  lib,
  config,
  ...
}: let
  cfg =
    config.servicesProfiles.adguardhome or {
      enable = false;
      rewrites = [];
    };
in {
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
