{
  lib,
  config,
  ...
}: let
  cfg = config.servicesProfiles.jellyfin;
in {
  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = false;
    };
  };
}
