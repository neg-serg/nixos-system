{
  lib,
  config,
  ...
}: let
  cfg = config.servicesProfiles.jellyfin;
in {
  options.servicesProfiles.jellyfin.enable = lib.mkEnableOption "Jellyfin media server profile";

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = false;
    };
  };
}
