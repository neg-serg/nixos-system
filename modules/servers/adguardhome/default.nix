{
  lib,
  config,
  ...
}: let
  cfg = config.servicesProfiles.adguardhome;
in {
  options.servicesProfiles.adguardhome.enable = lib.mkEnableOption "AdGuard Home profile";

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
          # Local rewrites so LAN clients can resolve Nextcloud host
          rewrites = [
            {
              domain = "telfir";
              answer = "192.168.2.240";
            }
            {
              domain = "telfir.local";
              answer = "192.168.2.240";
            }
          ];
        };
      };
    };
  };
}
