{ lib, config, pkgs, ... }:
let
  hasNcSecret = builtins.pathExists (../../.. + "/secrets/nextcloud.sops.yaml");
in {
  # Register SOPS secret only if the file exists to avoid eval errors
  sops.secrets."nextcloud/admin-pass" = lib.mkIf hasNcSecret {
    sopsFile = ../../../secrets/nextcloud.sops.yaml;
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "localhost";
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
}
