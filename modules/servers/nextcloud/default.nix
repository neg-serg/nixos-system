{
  lib,
  config,
  pkgs,
  ...
}: let
  hasNcSecret = builtins.pathExists (../../.. + "/secrets/nextcloud.sops.yaml");
  cfg = config.servicesProfiles.nextcloud;
in {
  # Optional: nginx reverse proxy + ACME integration (guarded by an enable flag)
  imports = [ ./nginx.nix ./caddy.nix ];

  options.servicesProfiles.nextcloud.enable = lib.mkEnableOption "Nextcloud server profile";

  config = lib.mkIf cfg.enable {
    # Register SOPS secret only if the file exists to avoid eval errors
    sops.secrets."nextcloud/admin-pass" = lib.mkIf hasNcSecret {
      sopsFile = ../../../secrets/nextcloud.sops.yaml;
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      # Default to localhost; override to a FQDN when exposing externally
      hostName = lib.mkDefault "localhost";
      database.createLocally = true;
      configureRedis = true;
      datadir = "/nextcloud";
      config =
        {
          adminuser = "init";
          dbtype = "mysql";
        }
        // (lib.optionalAttrs hasNcSecret {
          adminpassFile = config.sops.secrets."nextcloud/admin-pass".path;
        });
    };
  };
}
